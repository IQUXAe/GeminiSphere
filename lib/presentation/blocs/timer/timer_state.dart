import 'package:equatable/equatable.dart';
import '../../../domain/entities/timer_entity.dart';
import '../../../domain/entities/alarm_entity.dart';

sealed class TimerState extends Equatable {
  const TimerState();
  @override
  List<Object?> get props => [];
}

final class TimerIdle extends TimerState {
  final List<TimerEntity> activeTimers;
  final List<AlarmEntity> activeAlarms;
  const TimerIdle({this.activeTimers = const [], this.activeAlarms = const []});
  @override
  List<Object?> get props => [activeTimers, activeAlarms];
}

final class TimerFiringState extends TimerState {
  final TimerEntity timer;
  const TimerFiringState(this.timer);
  @override
  List<Object?> get props => [timer];
}

final class AlarmFiringState extends TimerState {
  final AlarmEntity alarm;
  const AlarmFiringState(this.alarm);
  @override
  List<Object?> get props => [alarm];
}
