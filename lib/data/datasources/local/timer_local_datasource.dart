import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../../models/timer_model.dart';
import '../../models/alarm_model.dart';
import '../../../core/errors/exceptions.dart';

class TimerLocalDataSource {
  static const String _timerBoxName = 'timers';
  static const String _alarmBoxName = 'alarms';

  final Logger _logger = Logger();
  Box<TimerModel>? _timerBox;
  Box<AlarmModel>? _alarmBox;

  Future<void> initialize() async {
    try {
      Hive.registerAdapter(TimerModelAdapter());
      Hive.registerAdapter(AlarmModelAdapter());
      _timerBox = await Hive.openBox<TimerModel>(_timerBoxName);
      _alarmBox = await Hive.openBox<AlarmModel>(_alarmBoxName);
      _logger.i('[TimerStorage] Initialized');
    } catch (e) {
      throw StorageException('Failed to initialize timer storage: $e');
    }
  }

  Future<void> saveTimer(TimerModel timer) async {
    await _timerBox!.put(timer.id, timer);
  }

  Future<TimerModel?> getTimer(String id) async {
    return _timerBox!.get(id);
  }

  Future<List<TimerModel>> getAllTimers() async {
    return _timerBox!.values.toList();
  }

  Future<void> deleteTimer(String id) async {
    await _timerBox!.delete(id);
  }

  Future<void> saveAlarm(AlarmModel alarm) async {
    await _alarmBox!.put(alarm.id, alarm);
  }

  Future<AlarmModel?> getAlarm(String id) async {
    return _alarmBox!.get(id);
  }

  Future<List<AlarmModel>> getAllAlarms() async {
    return _alarmBox!.values.toList();
  }

  Future<void> deleteAlarm(String id) async {
    await _alarmBox!.delete(id);
  }

  Future<void> dispose() async {
    await _timerBox?.close();
    await _alarmBox?.close();
  }
}
