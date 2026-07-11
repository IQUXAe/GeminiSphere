import 'package:freezed_annotation/freezed_annotation.dart';
part 'alarm_entity.freezed.dart';

@freezed
class AlarmEntity with _$AlarmEntity {
  const factory AlarmEntity({
    required String id,
    required String label,
    required int hour,
    required int minute,
    required DateTime scheduledTime,
    @Default(false) bool isFired,
    @Default(false) bool isCancelled,
  }) = _AlarmEntity;

  const AlarmEntity._();

  bool get isActive => !isFired && !isCancelled;
}
