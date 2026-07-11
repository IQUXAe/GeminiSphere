import 'package:equatable/equatable.dart';

enum SessionPhase {
  idle,       // Waiting for wake word (AOD mode)
  connecting, // Establishing WebSocket
  listening,  // WebSocket open, mic streaming
  speaking,   // Gemini is producing audio
  toolCalling,// Gemini called a function, processing
  error,      // Error state
}

class SessionState extends Equatable {
  final SessionPhase phase;
  final String? errorMessage;
  final bool isWakeWordEnabled;
  final int audioChunksReceived;  // For sphere animation amplitude
  final double audioAmplitude;    // 0.0 - 1.0 for sphere animation
  
  const SessionState({
    this.phase = SessionPhase.idle,
    this.errorMessage,
    this.isWakeWordEnabled = true,
    this.audioChunksReceived = 0,
    this.audioAmplitude = 0.0,
  });
  
  bool get isIdle => phase == SessionPhase.idle;
  bool get isListening => phase == SessionPhase.listening;
  bool get isSpeaking => phase == SessionPhase.speaking;
  bool get isActive => phase != SessionPhase.idle && phase != SessionPhase.error;
  
  SessionState copyWith({
    SessionPhase? phase,
    String? errorMessage,
    bool? isWakeWordEnabled,
    int? audioChunksReceived,
    double? audioAmplitude,
  }) {
    return SessionState(
      phase: phase ?? this.phase,
      errorMessage: phase == SessionPhase.error ? errorMessage ?? this.errorMessage : null,
      isWakeWordEnabled: isWakeWordEnabled ?? this.isWakeWordEnabled,
      audioChunksReceived: audioChunksReceived ?? this.audioChunksReceived,
      audioAmplitude: audioAmplitude ?? this.audioAmplitude,
    );
  }
  
  @override
  List<Object?> get props => [phase, errorMessage, isWakeWordEnabled, audioChunksReceived, audioAmplitude];
}
