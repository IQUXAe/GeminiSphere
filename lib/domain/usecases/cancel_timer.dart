import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/i_timer_repository.dart';
import '../../core/errors/failures.dart';

class CancelTimerParams {
  final String? timerId;
  final String? label;
  const CancelTimerParams({this.timerId, this.label});
}

@injectable
class CancelTimer {
  final ITimerRepository _repository;
  const CancelTimer(this._repository);

  Future<Either<Failure, void>> call(CancelTimerParams params) async {
    if (params.timerId != null) {
      return _repository.cancelTimer(params.timerId!);
    }
    if (params.label != null) {
      final result = await _repository.getActiveTimers();
      return result.fold(
        Left.new,
        (timers) async {
          final match = timers.where(
            (t) => t.label.toLowerCase().contains(params.label!.toLowerCase()),
          ).toList();
          if (match.isEmpty) return const Left(Failure.server(message: 'No timer found with that label'));
          return _repository.cancelTimer(match.first.id);
        },
      );
    }
    return const Left(Failure.server(message: 'No timer ID or label provided'));
  }
}
