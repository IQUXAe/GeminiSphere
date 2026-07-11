import 'dart:convert';
import '../../domain/entities/tool_call.dart';

/// Represents a parsed server message from the Gemini Live API WebSocket.
class GeminiServerMessage {
  final List<int>? audioPcmData; // base64-decoded PCM if it's audio
  final GeminiToolCallMessage? toolCall;
  final bool? turnComplete;
  final bool? interrupted;

  const GeminiServerMessage({
    this.audioPcmData,
    this.toolCall,
    this.turnComplete,
    this.interrupted,
  });

  /// Parses a raw JSON string from the WebSocket into a [GeminiServerMessage].
  /// Returns null if the message is unrecognized or parsing fails.
  static GeminiServerMessage? parse(String rawJson) {
    try {
      final json = jsonDecode(rawJson) as Map<String, dynamic>;

      // Audio / model turn response
      if (json.containsKey('serverContent')) {
        final serverContent = json['serverContent'] as Map<String, dynamic>;
        final turnComplete = serverContent['turnComplete'] as bool?;
        final interrupted = serverContent['interrupted'] as bool?;

        List<int>? audioPcm;
        final modelTurn = serverContent['modelTurn'] as Map<String, dynamic>?;
        if (modelTurn != null) {
          final parts = modelTurn['parts'] as List<dynamic>?;
          if (parts != null) {
            for (final part in parts) {
              final inlineData = part['inlineData'] as Map<String, dynamic>?;
              if (inlineData != null) {
                final mimeType = inlineData['mimeType'] as String? ?? '';
                if (mimeType.startsWith('audio/pcm')) {
                  final data = inlineData['data'] as String;
                  audioPcm = base64Decode(data);
                }
              }
            }
          }
        }

        return GeminiServerMessage(
          audioPcmData: audioPcm,
          turnComplete: turnComplete,
          interrupted: interrupted,
        );
      }

      // Tool call from the model
      if (json.containsKey('toolCall')) {
        final toolCallJson = json['toolCall'] as Map<String, dynamic>;
        return GeminiServerMessage(
          toolCall: GeminiToolCallMessage.fromJson(toolCallJson),
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Wraps the list of function calls returned by Gemini in a tool-call message.
class GeminiToolCallMessage {
  final List<GeminiFunctionCallItem> functionCalls;

  const GeminiToolCallMessage({required this.functionCalls});

  factory GeminiToolCallMessage.fromJson(Map<String, dynamic> json) {
    final calls = json['functionCalls'] as List<dynamic>? ?? [];
    return GeminiToolCallMessage(
      functionCalls: calls
          .map((c) => GeminiFunctionCallItem.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts Gemini-specific function calls to domain-layer [ToolCall] entities.
  List<ToolCall> toToolCalls() {
    return functionCalls
        .map((fc) => ToolCall(
              id: fc.id,
              name: fc.name,
              args: fc.args,
            ))
        .toList();
  }
}

/// A single function call item returned by the Gemini model.
class GeminiFunctionCallItem {
  final String id;
  final String name;
  final Map<String, dynamic> args;

  const GeminiFunctionCallItem({
    required this.id,
    required this.name,
    required this.args,
  });

  factory GeminiFunctionCallItem.fromJson(Map<String, dynamic> json) {
    return GeminiFunctionCallItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      args: (json['args'] as Map<String, dynamic>?) ?? {},
    );
  }
}

/// Message sent back to Gemini to deliver tool (function) execution results.
class GeminiToolResponseMessage {
  final List<GeminiFunctionResponse> functionResponses;

  const GeminiToolResponseMessage({required this.functionResponses});

  String toJsonString() {
    return jsonEncode({
      'tool_response': {
        'function_responses':
            functionResponses.map((r) => r.toJson()).toList(),
      },
    });
  }
}

/// A single function response payload to send back to the Gemini model.
class GeminiFunctionResponse {
  final String id;
  final String name;
  final dynamic response;

  const GeminiFunctionResponse({
    required this.id,
    required this.name,
    required this.response,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'response': response,
  };
}
