import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/repositories/i_alarm_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local/timer_local_datasource.dart';
import '../datasources/local/notification_datasource.dart';
import '../models/alarm_model.dart';

@LazySingleton(as: IAlarmRepository)
class AlarmRepositoryImpl implements IAlarmRepository {
  final TimerLocalDataSource _storage;
  final NotificationDataSource _notifications;
  final _uuid = const Uuid();

  final StreamController<AlarmEntity> _firedController =
      StreamController<AlarmEntity>.broadcast();

  /// In-memory Dart timers for precise in-process firing.
  final Map<String, Timer> _activeAlarmTimers = {};

  AlarmRepositoryImpl(this._storage, this._notifications);

  @override
  Future<Either<Failure, AlarmEntity>> createAlarm({
    required String label,
    required int hour,
    required int minute,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      var scheduled = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time has already passed today, schedule for tomorrow
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final entity = AlarmEntity(
        id: id,
        label: label,
        hour: hour,
        minute: minute,
        scheduledTime: scheduled,
      );

      // Persist to storage
      await _storage.saveAlarm(AlarmModel.fromEntity(entity));

      // Schedule local push notification
      // Offset alarm notification IDs by 500000 to avoid collision with timer IDs
      final notifId = (id.hashCode.abs() % 1000000) + 500000;
      await _notifications.scheduleTimerNotification(
        notificationId: notifId,
        title: '\u23F0 $label',
        body:
            'Alarm: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        scheduledTime: scheduled,
      );

      // In-memory timer
      final delay = scheduled.difference(DateTime.now());
      if (delay.isNegative) return Right(entity);

      _activeAlarmTimers[id] = Timer(delay, () {
        _onAlarmFired(entity);
      });

      return Right(entity);
    } on StorageException catch (e) {
      return Left(Failure.storage(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  void _onAlarmFired(AlarmEntity entity) async {
    _activeAlarmTimers.remove(entity.id);
    final fired = entity.copyWith(isFired: true);
    await _storage.saveAlarm(AlarmModel.fromEntity(fired));
    if (!_firedController.isClosed) {
      _firedController.add(fired);
    }
  }

  @override
  Future<Either<Failure, void>> cancelAlarm(String alarmId) async {
    try {
      _activeAlarmTimers[alarmId]?.cancel();
      _activeAlarmTimers.remove(alarmId);

      final notifId = (alarmId.hashCode.abs() % 1000000) + 500000;
      await _notifications.cancelNotification(notifId);

      final model = await _storage.getAlarm(alarmId);
      if (model != null) {
        final cancelled = model.toEntity().copyWith(isCancelled: true);
        await _storage.saveAlarm(AlarmModel.fromEntity(cancelled));
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlarmEntity>>> getActiveAlarms() async {
    try {
      final all = await _storage.getAllAlarms();
      return Right(
        all.map((m) => m.toEntity()).where((a) => a.isActive).toList(),
      );
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAlarmFired(String alarmId) async {
    try {
      final model = await _storage.getAlarm(alarmId);
      if (model != null) {
        final fired = model.toEntity().copyWith(isFired: true);
        await _storage.saveAlarm(AlarmModel.fromEntity(fired));
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Stream<AlarmEntity> get alarmFiredStream => _firedController.stream;
}
