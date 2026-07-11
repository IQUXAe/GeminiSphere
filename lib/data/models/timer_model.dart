import 'package:hive/hive.dart';
import '../../domain/entities/timer_entity.dart';

part 'timer_model.g.dart';

/// Hive-storable model representing a countdown timer.
/// Mirrors [TimerEntity] but with Hive persistence annotations.
@HiveType(typeId: 1)
class TimerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final int durationSeconds;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? firedAt;

  @HiveField(5)
  final bool isCancelled;

  TimerModel({
    required this.id,
    required this.label,
    required this.durationSeconds,
    required this.createdAt,
    this.firedAt,
    this.isCancelled = false,
  });

  /// Creates a [TimerModel] from the domain [TimerEntity].
  factory TimerModel.fromEntity(TimerEntity entity) => TimerModel(
        id: entity.id,
        label: entity.label,
        durationSeconds: entity.durationSeconds,
        createdAt: entity.createdAt,
        firedAt: entity.firedAt,
        isCancelled: entity.isCancelled,
      );

  /// Converts this Hive model back to the domain [TimerEntity].
  TimerEntity toEntity() => TimerEntity(
        id: id,
        label: label,
        durationSeconds: durationSeconds,
        createdAt: createdAt,
        firedAt: firedAt,
        isCancelled: isCancelled,
      );
}
