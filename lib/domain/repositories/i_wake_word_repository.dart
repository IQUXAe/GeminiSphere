import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

class WakeWordDetectedEvent {
  final String keyword;
  final double confidence;

  const WakeWordDetectedEvent({
    required this.keyword,
    required this.confidence,
  });
}

abstract interface class IWakeWordRepository {
  /// Initialize Vosk models and start listening for wake word
  Future<Either<Failure, void>> startListening();

  /// Stop wake word detection
  Future<Either<Failure, void>> stopListening();

  /// Stream emitting events when wake word is detected
  Stream<WakeWordDetectedEvent> get wakeWordStream;

  bool get isListening;
}
