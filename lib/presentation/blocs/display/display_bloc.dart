import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'display_event.dart';
import 'display_state.dart';

@injectable
class DisplayBloc extends Bloc<DisplayEvent, DisplayState> {
  DisplayBloc() : super(DisplayState.aod) {
    on<EnterAodMode>(_onEnterAod);
    on<EnterActiveMode>(_onEnterActive);
    on<EnterAlarmRinging>(_onEnterAlarmRinging);
    on<DismissAlarm>(_onDismissAlarm);
    on<SnoozeAlarm>(_onSnoozeAlarm);
    _initDisplay();
  }

  void _initDisplay() {
    // Keep screen on always (wakelock)
    WakelockPlus.enable();
    _applyBrightness(DisplayState.aod.brightness);
  }

  Future<void> _onEnterAod(EnterAodMode event, Emitter<DisplayState> emit) async {
    emit(DisplayState.aod);
    await _applyBrightness(DisplayState.aod.brightness);
  }

  Future<void> _onEnterActive(EnterActiveMode event, Emitter<DisplayState> emit) async {
    emit(DisplayState.active);
    await _applyBrightness(DisplayState.active.brightness);
  }

  Future<void> _onEnterAlarmRinging(EnterAlarmRinging event, Emitter<DisplayState> emit) async {
    emit(DisplayState.alarmRinging);
    await _applyBrightness(DisplayState.alarmRinging.brightness);
  }

  Future<void> _onDismissAlarm(DismissAlarm event, Emitter<DisplayState> emit) async {
    emit(DisplayState.aod);
    await _applyBrightness(DisplayState.aod.brightness);
  }

  Future<void> _onSnoozeAlarm(SnoozeAlarm event, Emitter<DisplayState> emit) async {
    emit(DisplayState.aod);
    await _applyBrightness(DisplayState.aod.brightness);
  }

  Future<void> _applyBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {
      // Screen brightness control may not be available on all platforms
    }
  }

  @override
  Future<void> close() async {
    try { await ScreenBrightness().resetScreenBrightness(); } catch (_) {}
    return super.close();
  }
}
