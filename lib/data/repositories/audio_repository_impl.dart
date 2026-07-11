import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_audio_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/audio_constants.dart';
import '../datasources/audio/microphone_datasource.dart';
import '../datasources/audio/audio_player_datasource.dart';

@LazySingleton(as: IAudioRepository)
class AudioRepositoryImpl implements IAudioRepository {
  final MicrophoneDataSource _mic;
  final AudioPlayerDataSource _player;
  AudioRepositoryImpl(this._mic, this._player);

  @override
  Future<Either<Failure, void>> startMicrophoneCapture() async {
    try {
      await _mic.start();
      return const Right(null);
    } on PermissionException catch (e) {
      return Left(Failure.permission(message: e.message));
    } on AudioException catch (e) {
      return Left(Failure.audio(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopMicrophoneCapture() async {
    try {
      await _mic.stop();
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  Stream<List<int>> get microphoneStream => _mic.stream ?? const Stream.empty();

  @override
  Future<Either<Failure, void>> playAudioChunk(List<int> pcmData) async {
    try {
      await _player.feedChunk(pcmData);
      return const Right(null);
    } on AudioException catch (e) {
      return Left(Failure.audio(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopPlayback() async {
    try {
      await _player.stopPlayback();
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> duckVolume() async {
    try {
      await _player.duckVolume();
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreVolume() async {
    try {
      await _player.restoreVolume();
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> startSilenceLoop() async {
    try {
      await _player.startSilenceLoop(kSilenceAudioAsset);
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopSilenceLoop() async {
    try {
      await _player.stopSilenceLoop();
      return const Right(null);
    } catch (e) {
      return Left(Failure.audio(message: e.toString()));
    }
  }

  @override
  bool get isMicrophoneActive => _mic.isActive;

  @override
  bool get isPlaying => _player.isPlaying;
}
