import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/tool_call.dart';
import '../repositories/i_gemini_repository.dart';
import '../../core/errors/failures.dart';
import 'set_timer.dart';
import 'cancel_timer.dart';
import 'list_active_timers.dart';
import 'set_alarm.dart';
import 'cancel_alarm.dart';

@injectable
class HandleToolCall {
  final IGeminiRepository _geminiRepo;
  final SetTimer _setTimer;
  final CancelTimer _cancelTimer;
  final ListActiveTimers _listTimers;
  final SetAlarm _setAlarm;
  final CancelAlarm _cancelAlarm;

  const HandleToolCall(
    this._geminiRepo,
    this._setTimer,
    this._cancelTimer,
    this._listTimers,
    this._setAlarm,
    this._cancelAlarm,
  );

  Future<Either<Failure, void>> call(ToolCall toolCall) async {
    dynamic result;
    switch (toolCall.name) {
      case 'set_timer':
        final label = (toolCall.args['label'] as String?) ?? 'Timer';
        final duration = toolCall.args['duration_seconds'] as int;
        final r = await _setTimer(SetTimerParams(label: label, durationSeconds: duration));
        result = r.fold(
          (f) => {'error': f.message},
          (timer) => {'timer_id': timer.id, 'label': timer.label, 'duration_seconds': timer.durationSeconds, 'status': 'started'},
        );
        break;
      case 'cancel_timer':
        final timerId = toolCall.args['timer_id'] as String?;
        final label = toolCall.args['label'] as String?;
        final r = await _cancelTimer(CancelTimerParams(timerId: timerId, label: label));
        result = r.fold((f) => {'error': f.message}, (_) => {'status': 'cancelled'});
        break;
      case 'list_timers':
        final r = await _listTimers();
        result = r.fold(
          (f) => {'error': f.message},
          (timers) => {'timers': timers.map((t) => {'id': t.id, 'label': t.label, 'remaining_seconds': t.remainingSeconds}).toList()},
        );
        break;
      case 'set_alarm':
        final hour = toolCall.args['hour'] as int;
        final minute = toolCall.args['minute'] as int;
        final label = (toolCall.args['label'] as String?) ?? 'Alarm';
        final r = await _setAlarm(SetAlarmParams(hour: hour, minute: minute, label: label));
        result = r.fold(
          (f) => {'error': f.message},
          (alarm) => {'alarm_id': alarm.id, 'label': alarm.label, 'scheduled_time': '${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}', 'status': 'set'},
        );
        break;
      case 'cancel_alarm':
        final alarmId = toolCall.args['alarm_id'] as String;
        final r = await _cancelAlarm(alarmId);
        result = r.fold((f) => {'error': f.message}, (_) => {'status': 'cancelled'});
        break;
      default:
        result = {'error': 'Unknown tool: ${toolCall.name}'};
    }

    return _geminiRepo.sendToolResponse(
      toolCallId: toolCall.id,
      toolName: toolCall.name,
      result: result,
    );
  }
}
