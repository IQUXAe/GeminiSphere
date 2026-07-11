import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:logger/logger.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/gemini_setup_message.dart';
import '../../models/gemini_tool_call_model.dart';
import '../../../domain/entities/tool_call.dart';

/// Low-level WebSocket datasource for the Gemini Live API.
///
/// Responsibilities:
/// - Open / close the persistent WebSocket connection.
/// - Send the session setup message on connect.
/// - Stream decoded PCM audio chunks from the model.
/// - Emit domain [ToolCall] events when the model requests tool execution.
/// - Send PCM audio input chunks from the microphone.
/// - Send tool execution results back to the model.
/// - Keep the connection alive with periodic pings.
class GeminiLiveDataSource {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _pingTimer;

  final _audioController = StreamController<List<int>>.broadcast();
  final _toolCallController = StreamController<ToolCall>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  final Logger _logger = Logger();
  bool _isConnected = false;

  // ── Public streams ────────────────────────────────────────────────────────

  /// Raw 16-bit PCM audio data chunks received from the Gemini model.
  Stream<List<int>> get audioStream => _audioController.stream;

  /// Domain-level tool call events emitted when the model invokes a function.
  Stream<ToolCall> get toolCallStream => _toolCallController.stream;

  /// Emits [true] when connected, [false] when disconnected or on error.
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Whether a live WebSocket session is currently open.
  bool get isConnected => _isConnected;

  // ── Connection lifecycle ──────────────────────────────────────────────────

  /// Opens a WebSocket connection to the Gemini Live API and sends the
  /// session setup message.
  ///
  /// Throws [GeminiApiException] if the connection cannot be established.
  Future<void> connect({
    required String apiKey,
    required String model,
    required String systemPrompt,
    required double temperature,
    required String thinkingLevel,
  }) async {
    if (_isConnected) await disconnect();

    final uri = Uri.parse('$kGeminiLiveApiBaseUrl?$kGeminiApiKeyParam=$apiKey');

    try {
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _isConnected = true;
      _connectionController.add(true);

      // Send session configuration
      final setupMsg = GeminiSetupMessage.create(
        model: model,
        systemPrompt: systemPrompt,
        temperature: temperature,
        thinkingLevel: thinkingLevel,
      );
      _channel!.sink.add(setupMsg.toJsonString());
      _logger.i('[Gemini] Connected and setup sent');

      // Listen for incoming messages
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: false,
      );

      // Start keepalive ping timer
      _pingTimer = Timer.periodic(
        const Duration(seconds: kWebSocketPingIntervalSeconds),
        (_) => _sendPing(),
      );
    } catch (e) {
      _isConnected = false;
      _connectionController.add(false);
      throw GeminiApiException(
        'Failed to connect to Gemini Live API: $e',
        cause: e,
      );
    }
  }

  /// Closes the WebSocket connection and cancels all internal timers.
  Future<void> disconnect() async {
    _pingTimer?.cancel();
    _pingTimer = null;

    await _subscription?.cancel();
    _subscription = null;

    await _channel?.sink.close(ws_status.normalClosure);
    _channel = null;

    _isConnected = false;
    _connectionController.add(false);
    _logger.i('[Gemini] Disconnected');
  }

  /// Closes all stream controllers. Call this when the object is no longer
  /// needed (e.g. in a Riverpod [onDispose] callback).
  Future<void> dispose() async {
    await disconnect();
    await _audioController.close();
    await _toolCallController.close();
    await _connectionController.close();
  }

  // ── Sending data ──────────────────────────────────────────────────────────

  /// Sends a 16-bit PCM audio chunk (sampled at 16 kHz) to the Gemini model.
  ///
  /// Throws [GeminiApiException] if not connected.
  void sendAudioChunk(List<int> pcmData) {
    _assertConnected();
    final base64Data = base64Encode(pcmData);
    final message = jsonEncode({
      'realtime_input': {
        'media_chunks': [
          {
            'mime_type': 'audio/pcm;rate=16000',
            'data': base64Data,
          }
        ],
      },
    });
    _channel!.sink.add(message);
  }

  /// Sends the result of a tool execution back to the Gemini model.
  ///
  /// [toolCallId] must match the [ToolCall.id] received from [toolCallStream].
  /// [result] should be a JSON-serialisable object.
  ///
  /// Throws [GeminiApiException] if not connected.
  void sendToolResponse({
    required String toolCallId,
    required String toolName,
    required dynamic result,
  }) {
    _assertConnected();
    final msg = GeminiToolResponseMessage(
      functionResponses: [
        GeminiFunctionResponse(
          id: toolCallId,
          name: toolName,
          response: result,
        ),
      ],
    );
    _channel!.sink.add(msg.toJsonString());
    _logger.d('[Gemini] Tool response sent for $toolName (id=$toolCallId)');
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _assertConnected() {
    if (!_isConnected || _channel == null) {
      throw GeminiApiException('Not connected to Gemini Live API');
    }
  }

  void _handleMessage(dynamic rawData) {
    try {
      final jsonStr =
          rawData is String ? rawData : utf8.decode(rawData as List<int>);
      final message = GeminiServerMessage.parse(jsonStr);
      if (message == null) return;

      // Dispatch audio data
      if (message.audioPcmData != null && message.audioPcmData!.isNotEmpty) {
        _audioController.add(message.audioPcmData!);
      }

      // Dispatch tool calls
      if (message.toolCall != null) {
        for (final tc in message.toolCall!.toToolCalls()) {
          _logger.d('[Gemini] Tool call received: ${tc.name} (id=${tc.id})');
          _toolCallController.add(tc);
        }
      }

      if (message.interrupted == true) {
        _logger.d('[Gemini] Turn interrupted by user activity');
      }
    } catch (e, st) {
      _logger.e('[Gemini] Error handling message', error: e, stackTrace: st);
    }
  }

  void _handleError(Object error) {
    _logger.e('[Gemini] WebSocket error: $error');
    _isConnected = false;
    _connectionController.add(false);
  }

  void _handleDone() {
    _logger.i('[Gemini] WebSocket connection closed by server');
    _isConnected = false;
    _connectionController.add(false);
  }

  /// Sends a lightweight keepalive message to prevent the server from closing
  /// an idle connection. The Gemini Live API treats an empty client_content
  /// turn as a no-op ping.
  void _sendPing() {
    if (!_isConnected || _channel == null) return;
    try {
      _channel!.sink.add(jsonEncode({
        'client_content': {'turns': [], 'turn_complete': false},
      }));
    } catch (e) {
      _logger.w('[Gemini] Keepalive ping failed: $e');
    }
  }
}
