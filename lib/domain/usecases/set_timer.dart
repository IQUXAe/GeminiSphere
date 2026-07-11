import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/timer_entity.dart';
import '../repositories/i_timer_repository.dart';
import '../../core/errors/failures.dart';

class SetTimerParams {
  final String label;
  final int durationSeconds;
  const SetTimerParams({required this.label, required this.durationSeconds});
}

@injectable
class SetTimer {
  final ITimerRepository _repository;
  const SetTimer(this._repository);

  Future<Either<Failure, TimerEntity>> call(SetTimerParams params) =>
      _repository.createTimer(label: params.label, durationSeconds: params.durationSeconds);
}
