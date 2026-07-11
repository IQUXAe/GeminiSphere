import 'package:dartz/dartz.dart';
import '../entities/alarm_entity.dart';
import '../../core/errors/failures.dart';

abstract interface class IAlarmRepository {
  Future<Either<Failure, AlarmEntity>> createAlarm({
    required String label,
    required int hour,
    required int minute,
  });

  Future<Either<Failure, void>> cancelAlarm(String alarmId);

  Future<Either<Failure, List<AlarmEntity>>> getActiveAlarms();

  Future<Either<Failure, void>> markAlarmFired(String alarmId);

  Stream<AlarmEntity> get alarmFiredStream;
}
