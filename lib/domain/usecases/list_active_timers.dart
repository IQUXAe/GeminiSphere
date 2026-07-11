import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/timer_entity.dart';
import '../repositories/i_timer_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class ListActiveTimers {
  final ITimerRepository _timerRepo;
  const ListActiveTimers(this._timerRepo);

  Future<Either<Failure, List<TimerEntity>>> call() =>
      _timerRepo.getActiveTimers();
}
