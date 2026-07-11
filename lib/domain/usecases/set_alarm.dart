import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/alarm_entity.dart';
import '../repositories/i_alarm_repository.dart';
import '../../core/errors/failures.dart';

class SetAlarmParams {
  final String label;
  final int hour;
  final int minute;
  const SetAlarmParams({required this.label, required this.hour, required this.minute});
}

@injectable
class SetAlarm {
  final IAlarmRepository _repository;
  const SetAlarm(this._repository);

  Future<Either<Failure, AlarmEntity>> call(SetAlarmParams params) =>
      _repository.createAlarm(label: params.label, hour: params.hour, minute: params.minute);
}
