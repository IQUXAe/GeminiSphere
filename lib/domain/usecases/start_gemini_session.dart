import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/i_gemini_repository.dart';
import '../../core/errors/failures.dart';

@injectable
class StartGeminiSession {
  final IGeminiRepository _repository;
  const StartGeminiSession(this._repository);

  Future<Either<Failure, void>> call(AppSettings settings) async {
    return _repository.startSession(
      apiKey: settings.apiKey,
      model: settings.model,
      systemPrompt: settings.systemPrompt,
      temperature: settings.temperature,
      thinkingLevel: settings.thinkingLevel.name,
    );
  }
}
