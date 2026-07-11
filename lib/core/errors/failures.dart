import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Sealed union of all application-level failures.
///
/// Each variant carries a human-readable [message] that can be surfaced
/// to the UI or logged for diagnostics.
@freezed
sealed class Failure with _$Failure {
  /// A failure originating from the Gemini API (HTTP / WebSocket errors,
  /// unexpected server responses, etc.).
  const factory Failure.server({required String message}) = ServerFailure;

  /// A failure related to audio capture or playback (device errors,
  /// codec issues, stream interruptions, etc.).
  const factory Failure.audio({required String message}) = AudioFailure;

  /// A failure in the wake-word detection subsystem (model load error,
  /// Vosk recognition failure, etc.).
  const factory Failure.wakeWord({required String message}) = WakeWordFailure;

  /// A failure when reading from or writing to persistent storage
  /// (shared preferences, SQLite, file I/O, etc.).
  const factory Failure.storage({required String message}) = StorageFailure;

  /// A failure caused by a missing or denied platform permission
  /// (microphone, notifications, etc.).
  const factory Failure.permission({required String message}) =
      PermissionFailure;

  /// A failure caused by network unavailability or connectivity issues.
  const factory Failure.network({required String message}) = NetworkFailure;

  /// A catch-all failure for unexpected or unclassified errors.
  const factory Failure.unknown({required String message}) = UnknownFailure;
}
