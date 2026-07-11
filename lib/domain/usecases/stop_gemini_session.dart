import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/i_gemini_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class StopGeminiSession {
  final IGeminiRepository _repository;
  const StopGeminiSession(this._repository);
  Future<Either<Failure, void>> call() => _repository.stopSession();
}
