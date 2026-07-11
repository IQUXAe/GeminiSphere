import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../repositories/i_gemini_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class SendAudioChunk {
  final IGeminiRepository _repository;
  const SendAudioChunk(this._repository);
  Future<Either<Failure, void>> call(List<int> pcmData) => _repository.sendAudioChunk(pcmData);
}
