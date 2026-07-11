import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/tool_call.dart';
import '../../../domain/usecases/start_gemini_session.dart';
import '../../../domain/usecases/stop_gemini_session.dart';
import '../../../domain/usecases/send_audio_chunk.dart';
import '../../../domain/usecases/handle_tool_call.dart';
import '../../../domain/usecases/load_settings.dart';
import '../../../domain/repositories/i_gemini_repository.dart';
import '../../../domain/repositories/i_audio_repository.dart';
import '../../../domain/repositories/i_wake_word_repository.dart';
import 'session_event.dart';
import 'session_state.dart';

@injectable
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final StartGeminiSession _startSession;
  final StopGeminiSession _stopSession;
  final SendAudioChunk _sendAudioChunk;
  final HandleToolCall _handleToolCall;
  final LoadSettings _loadSettings;
  final IGeminiRepository _geminiRepo;
  final IAudioRepository _audioRepo;
  final IWakeWordRepository _wakeWordRepo;

  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<List<int>>? _micSub;
  StreamSubscription<List<int>>? _geminiAudioSub;
  StreamSubscription<ToolCall>? _toolCallSub;
  StreamSubscription? _wakeWordSub;
  Timer? _sessionTimeoutTimer;
  Timer? _sessionTimeoutChecker;

  SessionBloc(
    this._startSession,
    this._stopSession,
    this._sendAudioChunk,
    this._handleToolCall,
    this._loadSettings,
    this._geminiRepo,
    this._audioRepo,
    this._wakeWordRepo,
  ) : super(const SessionState()) {
    on<WakeWordDetected>(_onWakeWordDetected);
    on<MicAudioChunkReceived>(_onMicAudioChunk);
    on<GeminiAudioChunkReceived>(_onGeminiAudioChunk);
    on<GeminiToolCallReceived>(_onToolCall);
    on<SessionTimedOut>(_onSessionTimedOut);
    on<SessionInterrupted>(_onSessionInterrupted);
    on<StopSessionRequested>(_onStopSession);
    on<ConnectionLost>(_onConnectionLost);
    _initWakeWordListener();
  }

  void _initWakeWordListener() {
    _wakeWordSub = _wakeWordRepo.wakeWordStream.listen((event) {
      add(WakeWordDetected(event.keyword));
    });
    _wakeWordRepo.startListening();
  }

  Future<void> _onWakeWordDetected(
    WakeWordDetected event,
    Emitter<SessionState> emit,
  ) async {
    if (state.phase != SessionPhase.idle) {
      // Already in a session or connecting; ignore
      return;
    }
    
    emit(state.copyWith(phase: SessionPhase.connecting));
    
    final settingsResult = await _loadSettings();
    final settings = settingsResult.fold(
      (_) => null,
      (s) => s,
    );
    
    if (settings == null || settings.apiKey.isEmpty) {
      emit(state.copyWith(
        phase: SessionPhase.error,
        errorMessage: 'API key not configured. Open Settings to add your Gemini API key.',
      ));
      return;
    }
    
    final result = await _startSession(settings);
    result.fold(
      (failure) => emit(state.copyWith(
        phase: SessionPhase.error,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(phase: SessionPhase.listening));
        _startStreaming();
        _resetSessionTimeout();
      },
    );
  }

  void _startStreaming() {
    // Subscribe to connection status
    _connectionSub = _geminiRepo.connectionStream.listen((connected) {
      if (!connected && state.isActive) {
        add(const ConnectionLost());
      }
    });
    
    // Start mic capture and pipe to Gemini
    _audioRepo.startMicrophoneCapture().then((result) {
      result.fold(
        (f) => emit(state.copyWith(phase: SessionPhase.error, errorMessage: f.message)),
        (_) {
          _micSub = _audioRepo.microphoneStream.listen((chunk) {
            add(MicAudioChunkReceived(chunk));
          });
        },
      );
    });
    
    // Subscribe to Gemini audio output
    _geminiAudioSub = _geminiRepo.audioResponseStream.listen((chunk) {
      add(GeminiAudioChunkReceived(chunk));
    });
    
    // Subscribe to tool calls
    _toolCallSub = _geminiRepo.toolCallStream.listen((toolCall) {
      add(GeminiToolCallReceived(
        toolCallId: toolCall.id,
        toolName: toolCall.name,
        args: toolCall.args,
      ));
    });
  }

  Future<void> _onMicAudioChunk(
    MicAudioChunkReceived event,
    Emitter<SessionState> emit,
  ) async {
    if (!state.isListening && state.phase != SessionPhase.speaking) return;
    await _sendAudioChunk(event.pcmData);
    _resetSessionTimeout();
  }

  Future<void> _onGeminiAudioChunk(
    GeminiAudioChunkReceived event,
    Emitter<SessionState> emit,
  ) async {
    // Play audio
    await _audioRepo.playAudioChunk(event.pcmData);
    
    // Calculate amplitude for sphere animation (RMS of PCM)
    final amplitude = _calculateAmplitude(event.pcmData);
    emit(state.copyWith(
      phase: SessionPhase.speaking,
      audioChunksReceived: state.audioChunksReceived + 1,
      audioAmplitude: amplitude,
    ));
    _resetSessionTimeout();
  }

  Future<void> _onToolCall(
    GeminiToolCallReceived event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(phase: SessionPhase.toolCalling));
    
    final toolCall = ToolCall(
      id: event.toolCallId,
      name: event.toolName,
      args: event.args,
    );
    
    await _handleToolCall(toolCall);
    
    // Return to listening after tool call
    if (!isClosed) {
      emit(state.copyWith(phase: SessionPhase.listening));
    }
  }

  Future<void> _onSessionTimedOut(
    SessionTimedOut event,
    Emitter<SessionState> emit,
  ) async {
    await _cleanupSession();
    emit(state.copyWith(phase: SessionPhase.idle));
  }

  Future<void> _onSessionInterrupted(
    SessionInterrupted event,
    Emitter<SessionState> emit,
  ) async {
    await _audioRepo.stopPlayback();
    emit(state.copyWith(phase: SessionPhase.listening, audioAmplitude: 0.0));
  }

  Future<void> _onStopSession(
    StopSessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    await _cleanupSession();
    emit(state.copyWith(phase: SessionPhase.idle));
  }

  Future<void> _onConnectionLost(
    ConnectionLost event,
    Emitter<SessionState> emit,
  ) async {
    await _cleanupSession();
    emit(state.copyWith(
      phase: SessionPhase.error,
      errorMessage: 'Connection lost. Say "Gemini" to reconnect.',
    ));
    // Auto-recover to idle after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      if (!isClosed && state.phase == SessionPhase.error) {
        emit(state.copyWith(phase: SessionPhase.idle));
      }
    });
  }

  Future<void> _cleanupSession() async {
    _sessionTimeoutTimer?.cancel();
    _sessionTimeoutTimer = null;
    await _micSub?.cancel();
    _micSub = null;
    await _geminiAudioSub?.cancel();
    _geminiAudioSub = null;
    await _toolCallSub?.cancel();
    _toolCallSub = null;
    await _connectionSub?.cancel();
    _connectionSub = null;
    await _audioRepo.stopMicrophoneCapture();
    await _audioRepo.stopPlayback();
    await _stopSession();
  }

  void _resetSessionTimeout() {
    _sessionTimeoutTimer?.cancel();
    _sessionTimeoutTimer = Timer(
      const Duration(seconds: 30), // 30s inactivity timeout
      () => add(const SessionTimedOut()),
    );
  }

  double _calculateAmplitude(List<int> pcmData) {
    if (pcmData.isEmpty) return 0.0;
    // Calculate RMS amplitude from 16-bit PCM samples
    double sum = 0;
    for (int i = 0; i < pcmData.length - 1; i += 2) {
      final sample = (pcmData[i + 1] << 8) | pcmData[i];
      final signed = sample > 32767 ? sample - 65536 : sample;
      sum += signed * signed;
    }
    final rms = sqrt(sum / (pcmData.length / 2));
    return (rms / 32768.0).clamp(0.0, 1.0);
  }

  @override
  Future<void> close() async {
    await _cleanupSession();
    await _wakeWordSub?.cancel();
    await _wakeWordRepo.stopListening();
    return super.close();
  }
}
