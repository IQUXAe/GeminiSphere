/// Application-level exception types.
///
/// These are thrown at the data / infrastructure layer and are caught by
/// repository implementations, which convert them into [Failure] values.
library;

// ---------------------------------------------------------------------------
// Gemini API
// ---------------------------------------------------------------------------

/// Thrown when the Gemini Live API returns an unexpected response,
/// a WebSocket error occurs, or the session cannot be established.
class GeminiApiException implements Exception {
  final String message;
  final Object? cause;

  const GeminiApiException(this.message, {this.cause});

  @override
  String toString() =>
      'GeminiApiException: $message'
      '${cause != null ? " (cause: $cause)" : ""}';
}

// ---------------------------------------------------------------------------
// Audio
// ---------------------------------------------------------------------------

/// Thrown when the audio capture or playback subsystem encounters an error
/// (e.g., device unavailable, stream interruption, codec failure).
class AudioException implements Exception {
  final String message;
  final Object? cause;

  const AudioException(this.message, {this.cause});

  @override
  String toString() =>
      'AudioException: $message'
      '${cause != null ? " (cause: $cause)" : ""}';
}

// ---------------------------------------------------------------------------
// Wake-word detection
// ---------------------------------------------------------------------------

/// Thrown when the wake-word detection engine (Vosk) fails to initialise,
/// load a model, or process an audio frame.
class WakeWordException implements Exception {
  final String message;
  final Object? cause;

  const WakeWordException(this.message, {this.cause});

  @override
  String toString() =>
      'WakeWordException: $message'
      '${cause != null ? " (cause: $cause)" : ""}';
}

// ---------------------------------------------------------------------------
// Storage
// ---------------------------------------------------------------------------

/// Thrown when reading from or writing to persistent storage fails
/// (shared preferences, SQLite, file I/O, etc.).
class StorageException implements Exception {
  final String message;
  final Object? cause;

  const StorageException(this.message, {this.cause});

  @override
  String toString() =>
      'StorageException: $message'
      '${cause != null ? " (cause: $cause)" : ""}';
}

// ---------------------------------------------------------------------------
// Permissions
// ---------------------------------------------------------------------------

/// Thrown when a required platform permission (microphone, notifications,
/// background execution, etc.) has been denied or is permanently revoked.
class PermissionException implements Exception {
  final String message;
  final Object? cause;

  const PermissionException(this.message, {this.cause});

  @override
  String toString() =>
      'PermissionException: $message'
      '${cause != null ? " (cause: $cause)" : ""}';
}
