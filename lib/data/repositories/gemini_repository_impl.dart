import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/tool_call.dart';
import '../../domain/repositories/i_gemini_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/gemini/gemini_live_datasource.dart';

@LazySingleton(as: IGeminiRepository)
class GeminiRepositoryImpl implements IGeminiRepository {
  final GeminiLiveDataSource _dataSource;
  GeminiRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> startSession({
    required String apiKey,
    required String model,
    required String systemPrompt,
    required double temperature,
    required String thinkingLevel,
  }) async {
    try {
      await _dataSource.connect(
        apiKey: apiKey,
        model: model,
        systemPrompt: systemPrompt,
        temperature: temperature,
        thinkingLevel: thinkingLevel,
      );
      return const Right(null);
    } on GeminiApiException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopSession() async {
    try {
      await _dataSource.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendAudioChunk(List<int> pcmData) async {
    try {
      _dataSource.sendAudioChunk(pcmData);
      return const Right(null);
    } on GeminiApiException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Stream<List<int>> get audioResponseStream => _dataSource.audioStream;

  @override
  Stream<ToolCall> get toolCallStream => _dataSource.toolCallStream;

  @override
  Stream<bool> get connectionStream => _dataSource.connectionStream;

  @override
  Future<Either<Failure, void>> sendToolResponse({
    required String toolCallId,
    required String toolName,
    required dynamic result,
  }) async {
    try {
      _dataSource.sendToolResponse(toolCallId: toolCallId, toolName: toolName, result: result);
      return const Right(null);
    } on GeminiApiException catch (e) {
      return Left(Failure.server(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  bool get isConnected => _dataSource.isConnected;
}
