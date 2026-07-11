import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_settings.freezed.dart';

enum ThinkingLevel { none, low, medium, high }
enum AodClockStyle { digital, minimal, outlined }
enum AppLanguage { ru, en, auto }

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required String apiKey,
    @Default('gemini-2.0-flash-live-001') String model,
    @Default('You are GeminiSphere, a helpful AI voice assistant. You are concise, warm, and speak naturally. You can speak both Russian and English depending on the user language. You have the ability to set timers and alarms. Always respond in the same language the user speaks to you.') String systemPrompt,
    @Default(1.0) double temperature,
    @Default(ThinkingLevel.low) ThinkingLevel thinkingLevel,
    @Default(0.6) double wakeWordSensitivity,
    @Default(AodClockStyle.digital) AodClockStyle aodClockStyle,
    @Default(30) int aodScrollSpeedSeconds,
    @Default(true) bool isFirstRun,
    @Default(AppLanguage.auto) AppLanguage language,
  }) = _AppSettings;

  const AppSettings._();

  static AppSettings get defaults => const AppSettings(apiKey: '');
}
