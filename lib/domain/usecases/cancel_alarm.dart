import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/i_alarm_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class CancelAlarm {
  final IAlarmRepository _repository;
  const CancelAlarm(this._repository);
  Future<Either<Failure, void>> call(String alarmId) => _repository.cancelAlarm(alarmId);
}
