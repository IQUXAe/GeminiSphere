import 'package:freezed_annotation/freezed_annotation.dart';
part 'timer_entity.freezed.dart';

@freezed
class TimerEntity with _$TimerEntity {
  const factory TimerEntity({
    required String id,
    required String label,
    required int durationSeconds,
    required DateTime createdAt,
    DateTime? firedAt,
    @Default(false) bool isCancelled,
  }) = _TimerEntity;

  const TimerEntity._();

  bool get isActive => firedAt == null && !isCancelled;

  DateTime get scheduledFireAt => createdAt.add(Duration(seconds: durationSeconds));

  int get remainingSeconds {
    if (!isActive) return 0;
    final remaining = scheduledFireAt.difference(DateTime.now()).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }
}
