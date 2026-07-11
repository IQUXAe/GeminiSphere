import 'package:equatable/equatable.dart';

enum DisplayMode { aod, active, alarmRinging }

class DisplayState extends Equatable {
  final DisplayMode mode;
  final double brightness;  // 0.0 - 1.0
  
  const DisplayState({
    this.mode = DisplayMode.aod,
    this.brightness = 0.05,
  });
  
  bool get isAod => mode == DisplayMode.aod;
  bool get isActive => mode == DisplayMode.active;
  bool get isAlarmRinging => mode == DisplayMode.alarmRinging;
  
  static const aod = DisplayState(mode: DisplayMode.aod, brightness: 0.02);
  static const active = DisplayState(mode: DisplayMode.active, brightness: 0.7);
  static const alarmRinging = DisplayState(mode: DisplayMode.alarmRinging, brightness: 1.0);
  
  @override
  List<Object?> get props => [mode, brightness];
}
