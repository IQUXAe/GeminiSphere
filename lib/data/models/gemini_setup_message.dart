import 'dart:convert';

/// Message sent to Gemini Live API WebSocket on connection to configure the session.
class GeminiSetupMessage {
  final String model;
  final GeminiGenerationConfig generationConfig;
  final String systemInstruction;
  final List<GeminiTool> tools;

  const GeminiSetupMessage({
    required this.model,
    required this.generationConfig,
    required this.systemInstruction,
    required this.tools,
  });

  Map<String, dynamic> toJson() => {
    'setup': {
      'model': model,
      'generation_config': generationConfig.toJson(),
      'system_instruction': {
        'parts': [{'text': systemInstruction}]
      },
      'tools': tools.map((t) => t.toJson()).toList(),
      'realtime_input_config': {
        'automatic_activity_detection': {
          'disabled': false,
        },
      },
    },
  };

  String toJsonString() => jsonEncode(toJson());

  /// Factory for creating the default GeminiSphere setup message.
  factory GeminiSetupMessage.create({
    required String model,
    required String systemPrompt,
    required double temperature,
    required String thinkingLevel,
  }) {
    return GeminiSetupMessage(
      model: model,
      generationConfig: GeminiGenerationConfig(
        responseModalities: ['AUDIO'],
        speechConfig: GeminiSpeechConfig(voiceName: 'Aoede'),
        temperature: temperature,
        thinkingConfig: GeminiThinkingConfig.fromLevel(thinkingLevel),
      ),
      systemInstruction: systemPrompt,
      tools: [GeminiTool.timerAndAlarmTools()],
    );
  }
}

class GeminiGenerationConfig {
  final List<String> responseModalities;
  final GeminiSpeechConfig speechConfig;
  final double temperature;
  final GeminiThinkingConfig? thinkingConfig;

  const GeminiGenerationConfig({
    required this.responseModalities,
    required this.speechConfig,
    this.temperature = 1.0,
    this.thinkingConfig,
  });

  Map<String, dynamic> toJson() => {
    'response_modalities': responseModalities,
    'speech_config': speechConfig.toJson(),
    'temperature': temperature,
    if (thinkingConfig != null) 'thinking_config': thinkingConfig!.toJson(),
  };
}

class GeminiSpeechConfig {
  final String voiceName;
  const GeminiSpeechConfig({this.voiceName = 'Aoede'});
  Map<String, dynamic> toJson() => {
    'voice_config': {'prebuilt_voice_config': {'voice_name': voiceName}}
  };
}

class GeminiThinkingConfig {
  final bool thinkingEnabled;
  final int? maxThinkingTokens;

  const GeminiThinkingConfig({
    required this.thinkingEnabled,
    this.maxThinkingTokens,
  });

  factory GeminiThinkingConfig.fromLevel(String level) {
    switch (level) {
      case 'none':
        return const GeminiThinkingConfig(thinkingEnabled: false, maxThinkingTokens: 0);
      case 'low':
        return const GeminiThinkingConfig(thinkingEnabled: true, maxThinkingTokens: 512);
      case 'medium':
        return const GeminiThinkingConfig(thinkingEnabled: true, maxThinkingTokens: 2048);
      case 'high':
        return const GeminiThinkingConfig(thinkingEnabled: true, maxThinkingTokens: 8192);
      default:
        return const GeminiThinkingConfig(thinkingEnabled: false);
    }
  }

  Map<String, dynamic> toJson() => {
    'thinking_enabled': thinkingEnabled,
    if (maxThinkingTokens != null) 'max_thinking_tokens': maxThinkingTokens,
  };
}

class GeminiTool {
  final List<GeminiFunctionDeclaration> functionDeclarations;
  const GeminiTool({required this.functionDeclarations});

  Map<String, dynamic> toJson() => {
    'function_declarations': functionDeclarations.map((f) => f.toJson()).toList(),
  };

  /// Returns all built-in timer and alarm tools for GeminiSphere.
  factory GeminiTool.timerAndAlarmTools() {
    return GeminiTool(functionDeclarations: [
      GeminiFunctionDeclaration(
        name: 'set_timer',
        description:
            'Set a countdown timer for the specified duration. Use this when the user asks to set a timer.',
        parameters: {
          'type': 'object',
          'properties': {
            'duration_seconds': {
              'type': 'integer',
              'description': 'Timer duration in seconds'
            },
            'label': {
              'type': 'string',
              'description': 'A short descriptive label for the timer (e.g. Pasta, Tea)'
            },
          },
          'required': ['duration_seconds'],
        },
      ),
      GeminiFunctionDeclaration(
        name: 'cancel_timer',
        description: 'Cancel an active timer by its ID or label.',
        parameters: {
          'type': 'object',
          'properties': {
            'timer_id': {
              'type': 'string',
              'description': 'The unique ID of the timer to cancel'
            },
            'label': {
              'type': 'string',
              'description': 'The label of the timer to cancel'
            },
          },
        },
      ),
      GeminiFunctionDeclaration(
        name: 'list_timers',
        description:
            'List all currently active timers and alarms with their remaining time.',
        parameters: {'type': 'object', 'properties': {}},
      ),
      GeminiFunctionDeclaration(
        name: 'set_alarm',
        description: 'Set an alarm for a specific time of day.',
        parameters: {
          'type': 'object',
          'properties': {
            'hour': {
              'type': 'integer',
              'description': '24-hour format hour (0-23)'
            },
            'minute': {'type': 'integer', 'description': 'Minute (0-59)'},
            'label': {'type': 'string', 'description': 'Label for the alarm'},
          },
          'required': ['hour', 'minute'],
        },
      ),
      GeminiFunctionDeclaration(
        name: 'cancel_alarm',
        description: 'Cancel an active alarm by its ID.',
        parameters: {
          'type': 'object',
          'properties': {
            'alarm_id': {
              'type': 'string',
              'description': 'The unique ID of the alarm to cancel'
            },
          },
          'required': ['alarm_id'],
        },
      ),
    ]);
  }
}

class GeminiFunctionDeclaration {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;

  const GeminiFunctionDeclaration({
    required this.name,
    required this.description,
    required this.parameters,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'parameters': parameters,
  };
}
