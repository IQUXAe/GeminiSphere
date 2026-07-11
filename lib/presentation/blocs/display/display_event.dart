import 'package:equatable/equatable.dart';

sealed class DisplayEvent extends Equatable {
  const DisplayEvent();
  @override
  List<Object?> get props => [];
}

final class EnterAodMode extends DisplayEvent { const EnterAodMode(); }
final class EnterActiveMode extends DisplayEvent { const EnterActiveMode(); }
final class EnterAlarmRinging extends DisplayEvent { const EnterAlarmRinging(); }
final class DismissAlarm extends DisplayEvent { const DismissAlarm(); }
final class SnoozeAlarm extends DisplayEvent {
  final int snoozeMinutes;
  const SnoozeAlarm({this.snoozeMinutes = 5});
  @override List<Object?> get props => [snoozeMinutes];
}
