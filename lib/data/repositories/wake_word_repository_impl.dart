import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_wake_word_repository.dart';
import '../../domain/repositories/i_audio_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/audio_constants.dart';
import '../datasources/wake_word/vosk_wake_word_datasource.dart';

@LazySingleton(as: IWakeWordRepository)
class WakeWordRepositoryImpl implements IWakeWordRepository {
  final VoskWakeWordDataSource _vosk;
  final IAudioRepository _audio;
  StreamSubscription<List<int>>? _micSub;
  bool _isListening = false;

  WakeWordRepositoryImpl(this._vosk, this._audio);

  @override
  Future<Either<Failure, void>> startListening() async {
    try {
      // Initialize Vosk models (paths should be resolved from app docs dir)
      await _vosk.initialize(
        kVoskModelEnAssetPath,
        kVoskModelRuAssetPath,
      );

      // Start microphone capture for wake word
      final micResult = await _audio.startMicrophoneCapture();
      return await micResult.fold(
        (failure) async => Left(failure),
        (_) async {
          _vosk.startListening();

          // Pipe mic audio to Vosk
          _micSub = _audio.microphoneStream.listen((chunk) {
            _vosk.processAudioChunk(chunk);
          });

          _isListening = true;
          return const Right(null);
        },
      );
    } on WakeWordException catch (e) {
      return Left(Failure.wakeWord(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopListening() async {
    try {
      _vosk.stopListening();
      await _micSub?.cancel();
      _micSub = null;
      await _audio.stopMicrophoneCapture();
      _isListening = false;
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<WakeWordDetectedEvent> get wakeWordStream => _vosk.stream;

  @override
  bool get isListening => _isListening;
}
