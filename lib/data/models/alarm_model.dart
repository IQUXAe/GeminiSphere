import 'package:hive/hive.dart';
import '../../domain/entities/alarm_entity.dart';

part 'alarm_model.g.dart';

/// Hive-storable model representing a time-of-day alarm.
/// Mirrors [AlarmEntity] but with Hive persistence annotations.
@HiveType(typeId: 2)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final int hour;

  @HiveField(3)
  final int minute;

  @HiveField(4)
  final DateTime scheduledTime;

  @HiveField(5)
  final bool isFired;

  @HiveField(6)
  final bool isCancelled;

  AlarmModel({
    required this.id,
    required this.label,
    required this.hour,
    required this.minute,
    required this.scheduledTime,
    this.isFired = false,
    this.isCancelled = false,
  });

  /// Creates an [AlarmModel] from the domain [AlarmEntity].
  factory AlarmModel.fromEntity(AlarmEntity entity) => AlarmModel(
        id: entity.id,
        label: entity.label,
        hour: entity.hour,
        minute: entity.minute,
        scheduledTime: entity.scheduledTime,
        isFired: entity.isFired,
        isCancelled: entity.isCancelled,
      );

  /// Converts this Hive model back to the domain [AlarmEntity].
  AlarmEntity toEntity() => AlarmEntity(
        id: id,
        label: label,
        hour: hour,
        minute: minute,
        scheduledTime: scheduledTime,
        isFired: isFired,
        isCancelled: isCancelled,
      );
}
