import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/repositories/i_timer_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local/timer_local_datasource.dart';
import '../datasources/local/notification_datasource.dart';
import '../models/timer_model.dart';

@LazySingleton(as: ITimerRepository)
class TimerRepositoryImpl implements ITimerRepository {
  final TimerLocalDataSource _storage;
  final NotificationDataSource _notifications;
  final _uuid = const Uuid();

  final StreamController<TimerEntity> _firedController =
      StreamController<TimerEntity>.broadcast();

  /// In-memory Dart timers for precise in-process firing.
  final Map<String, Timer> _activeTimers = {};

  TimerRepositoryImpl(this._storage, this._notifications);

  @override
  Future<Either<Failure, TimerEntity>> createTimer({
    required String label,
    required int durationSeconds,
  }) async {
    try {
      final id = _uuid.v4();
      final now = DateTime.now();
      final entity = TimerEntity(
        id: id,
        label: label,
        durationSeconds: durationSeconds,
        createdAt: now,
      );

      // Persist to Hive
      final model = TimerModel.fromEntity(entity);
      await _storage.saveTimer(model);

      // Schedule local push notification (survives process death)
      final notifId = id.hashCode.abs() % 1000000;
      await _notifications.scheduleTimerNotification(
        notificationId: notifId,
        title: '\u23F0 $label',
        body: 'Timer has finished!',
        scheduledTime: entity.scheduledFireAt,
      );

      // In-memory timer (more precise than OS notifications alone)
      _activeTimers[id] = Timer(Duration(seconds: durationSeconds), () {
        _onTimerFired(entity);
      });

      return Right(entity);
    } on StorageException catch (e) {
      return Left(Failure.storage(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  void _onTimerFired(TimerEntity entity) async {
    _activeTimers.remove(entity.id);
    final firedEntity = entity.copyWith(firedAt: DateTime.now());
    await _storage.saveTimer(TimerModel.fromEntity(firedEntity));
    if (!_firedController.isClosed) {
      _firedController.add(firedEntity);
    }
  }

  @override
  Future<Either<Failure, void>> cancelTimer(String timerId) async {
    try {
      // Cancel in-memory timer
      _activeTimers[timerId]?.cancel();
      _activeTimers.remove(timerId);

      // Cancel scheduled notification
      final notifId = timerId.hashCode.abs() % 1000000;
      await _notifications.cancelNotification(notifId);

      // Mark as cancelled in storage
      final model = await _storage.getTimer(timerId);
      if (model != null) {
        final cancelled = model.toEntity().copyWith(isCancelled: true);
        await _storage.saveTimer(TimerModel.fromEntity(cancelled));
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TimerEntity>>> getActiveTimers() async {
    try {
      final all = await _storage.getAllTimers();
      final active = all
          .map((m) => m.toEntity())
          .where((t) => t.isActive)
          .toList();
      return Right(active);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TimerEntity?>> getTimer(String timerId) async {
    try {
      final model = await _storage.getTimer(timerId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markTimerFired(String timerId) async {
    try {
      final model = await _storage.getTimer(timerId);
      if (model != null) {
        final fired = model.toEntity().copyWith(firedAt: DateTime.now());
        await _storage.saveTimer(TimerModel.fromEntity(fired));
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Stream<TimerEntity> get timerFiredStream => _firedController.stream;
}
