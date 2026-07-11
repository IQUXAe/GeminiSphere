import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract interface class IAudioRepository {
  /// Start capturing PCM audio from microphone
  Future<Either<Failure, void>> startMicrophoneCapture();

  /// Stop microphone capture
  Future<Either<Failure, void>> stopMicrophoneCapture();

  /// Stream of raw PCM chunks from microphone (16kHz, 16-bit, mono)
  Stream<List<int>> get microphoneStream;

  /// Play PCM audio chunk immediately (24kHz, 16-bit, mono)
  Future<Either<Failure, void>> playAudioChunk(List<int> pcmData);

  /// Stop all audio playback
  Future<Either<Failure, void>> stopPlayback();

  /// Duck (lower) volume for alarm mode
  Future<Either<Failure, void>> duckVolume();

  /// Restore normal volume
  Future<Either<Failure, void>> restoreVolume();

  /// Start looping silence file (iOS background keepalive)
  Future<Either<Failure, void>> startSilenceLoop();

  /// Stop silence loop
  Future<Either<Failure, void>> stopSilenceLoop();

  bool get isMicrophoneActive;
  bool get isPlaying;
}
