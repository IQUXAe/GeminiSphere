import 'package:equatable/equatable.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

/// Wake word was detected by Vosk
final class WakeWordDetected extends SessionEvent {
  final String keyword;
  const WakeWordDetected(this.keyword);
  @override
  List<Object?> get props => [keyword];
}

/// Raw PCM audio chunk received from microphone during active session
final class MicAudioChunkReceived extends SessionEvent {
  final List<int> pcmData;
  const MicAudioChunkReceived(this.pcmData);
  @override
  List<Object?> get props => [pcmData];
}

/// PCM audio response chunk received from Gemini
final class GeminiAudioChunkReceived extends SessionEvent {
  final List<int> pcmData;
  const GeminiAudioChunkReceived(this.pcmData);
  @override
  List<Object?> get props => [pcmData];
}

/// Gemini sent a tool call
final class GeminiToolCallReceived extends SessionEvent {
  final String toolCallId;
  final String toolName;
  final Map<String, dynamic> args;
  const GeminiToolCallReceived({required this.toolCallId, required this.toolName, required this.args});
  @override
  List<Object?> get props => [toolCallId, toolName, args];
}

/// Session timed out (no activity for kSessionTimeoutSeconds)
final class SessionTimedOut extends SessionEvent {
  const SessionTimedOut();
}

/// User or system interrupted Gemini response mid-speech
final class SessionInterrupted extends SessionEvent {
  const SessionInterrupted();
}

/// Stop the session manually
final class StopSessionRequested extends SessionEvent {
  const StopSessionRequested();
}

/// Settings updated, need to use new config for next session
final class SettingsUpdated extends SessionEvent {
  const SettingsUpdated();
}

/// WebSocket connection lost
final class ConnectionLost extends SessionEvent {
  const ConnectionLost();
}
