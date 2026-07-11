import 'package:dartz/dartz.dart';
import '../entities/timer_entity.dart';
import '../../core/errors/failures.dart';

abstract interface class ITimerRepository {
  Future<Either<Failure, TimerEntity>> createTimer({
    required String label,
    required int durationSeconds,
  });

  Future<Either<Failure, void>> cancelTimer(String timerId);

  Future<Either<Failure, List<TimerEntity>>> getActiveTimers();

  Future<Either<Failure, TimerEntity?>> getTimer(String timerId);

  Future<Either<Failure, void>> markTimerFired(String timerId);

  Stream<TimerEntity> get timerFiredStream;
}
