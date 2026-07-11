import 'package:equatable/equatable.dart';
import '../../../domain/entities/timer_entity.dart';
import '../../../domain/entities/alarm_entity.dart';

sealed class TimerEvent extends Equatable {
  const TimerEvent();
  @override
  List<Object?> get props => [];
}

final class LoadTimers extends TimerEvent {
  const LoadTimers();
}

final class TimerFiredEvent extends TimerEvent {
  final TimerEntity timer;
  const TimerFiredEvent(this.timer);
  @override
  List<Object?> get props => [timer];
}

final class AlarmFiredEvent extends TimerEvent {
  final AlarmEntity alarm;
  const AlarmFiredEvent(this.alarm);
  @override
  List<Object?> get props => [alarm];
}

final class DismissAlert extends TimerEvent {
  final String id;
  const DismissAlert(this.id);
  @override
  List<Object?> get props => [id];
}
