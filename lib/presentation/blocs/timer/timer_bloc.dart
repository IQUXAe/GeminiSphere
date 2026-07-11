import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/i_timer_repository.dart';
import '../../../domain/repositories/i_alarm_repository.dart';
import 'timer_event.dart';
import 'timer_state.dart';

@injectable
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final ITimerRepository _timerRepo;
  final IAlarmRepository _alarmRepo;
  StreamSubscription? _timerFiredSub;
  StreamSubscription? _alarmFiredSub;

  TimerBloc(this._timerRepo, this._alarmRepo)
      : super(const TimerIdle()) {
    on<LoadTimers>(_onLoadTimers);
    on<TimerFiredEvent>(_onTimerFired);
    on<AlarmFiredEvent>(_onAlarmFired);
    on<DismissAlert>(_onDismissAlert);
    
    // Listen to fired streams
    _timerFiredSub = _timerRepo.timerFiredStream.listen((timer) {
      add(TimerFiredEvent(timer));
    });
    _alarmFiredSub = _alarmRepo.alarmFiredStream.listen((alarm) {
      add(AlarmFiredEvent(alarm));
    });
  }

  Future<void> _onLoadTimers(LoadTimers event, Emitter<TimerState> emit) async {
    final timersResult = await _timerRepo.getActiveTimers();
    final alarmsResult = await _alarmRepo.getActiveAlarms();
    
    final timers = timersResult.fold((_) => <dynamic>[], (t) => t);
    final alarms = alarmsResult.fold((_) => <dynamic>[], (a) => a);
    
    emit(TimerIdle(
      activeTimers: timers.cast(),
      activeAlarms: alarms.cast(),
    ));
  }

  Future<void> _onTimerFired(TimerFiredEvent event, Emitter<TimerState> emit) async {
    emit(TimerFiringState(event.timer));
  }

  Future<void> _onAlarmFired(AlarmFiredEvent event, Emitter<TimerState> emit) async {
    emit(AlarmFiringState(event.alarm));
  }

  Future<void> _onDismissAlert(DismissAlert event, Emitter<TimerState> emit) async {
    emit(const TimerIdle());
    add(const LoadTimers());
  }

  @override
  Future<void> close() async {
    await _timerFiredSub?.cancel();
    await _alarmFiredSub?.cancel();
    return super.close();
  }
}
