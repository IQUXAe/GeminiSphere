import 'package:dartz/dartz.dart';
import '../entities/tool_call.dart';
import '../../core/errors/failures.dart';

abstract interface class IGeminiRepository {
  /// Establish WebSocket connection and start streaming session
  Future<Either<Failure, void>> startSession({
    required String apiKey,
    required String model,
    required String systemPrompt,
    required double temperature,
    required String thinkingLevel,
  });

  /// Close WebSocket session gracefully
  Future<Either<Failure, void>> stopSession();

  /// Send raw PCM audio chunk to Gemini
  Future<Either<Failure, void>> sendAudioChunk(List<int> pcmData);

  /// Stream of incoming PCM audio chunks from Gemini (24kHz, 16-bit, mono)
  Stream<List<int>> get audioResponseStream;

  /// Stream of tool calls from Gemini
  Stream<ToolCall> get toolCallStream;

  /// Stream of session status booleans (true = connected)
  Stream<bool> get connectionStream;

  /// Send tool response back to Gemini
  Future<Either<Failure, void>> sendToolResponse({
    required String toolCallId,
    required dynamic result,
  });

  bool get isConnected;
}
