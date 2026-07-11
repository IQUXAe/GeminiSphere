import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../core/errors/exceptions.dart';

class SettingsDataSource {
  static const String _keyApiKey = 'api_key';
  static const String _keyModel = 'model';
  static const String _keySystemPrompt = 'system_prompt';
  static const String _keyTemperature = 'temperature';
  static const String _keyThinkingLevel = 'thinking_level';
  static const String _keyWakeWordSensitivity = 'wake_word_sensitivity';
  static const String _keyAodClockStyle = 'aod_clock_style';
  static const String _keyAodScrollSpeed = 'aod_scroll_speed';
  static const String _keyIsFirstRun = 'is_first_run';
  static const String _keyLanguage = 'language';

  final Logger _logger = Logger();

  Future<AppSettings> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final apiKey = prefs.getString(_keyApiKey) ?? '';
      final model = prefs.getString(_keyModel) ?? 'gemini-2.0-flash-live-001';
      final systemPrompt = prefs.getString(_keySystemPrompt) ?? AppSettings.defaults.systemPrompt;
      final temperature = prefs.getDouble(_keyTemperature) ?? 1.0;
      final thinkingLevelStr = prefs.getString(_keyThinkingLevel) ?? ThinkingLevel.low.name;
      final thinkingLevel = ThinkingLevel.values.firstWhere(
        (e) => e.name == thinkingLevelStr,
        orElse: () => ThinkingLevel.low,
      );
      final wakeWordSensitivity = prefs.getDouble(_keyWakeWordSensitivity) ?? 0.6;
      final aodClockStyleStr = prefs.getString(_keyAodClockStyle) ?? AodClockStyle.digital.name;
      final aodClockStyle = AodClockStyle.values.firstWhere(
        (e) => e.name == aodClockStyleStr,
        orElse: () => AodClockStyle.digital,
      );
      final aodScrollSpeed = prefs.getInt(_keyAodScrollSpeed) ?? 30;
      final isFirstRun = prefs.getBool(_keyIsFirstRun) ?? true;
      final languageStr = prefs.getString(_keyLanguage) ?? AppLanguage.auto.name;
      final language = AppLanguage.values.firstWhere(
        (e) => e.name == languageStr,
        orElse: () => AppLanguage.auto,
      );

      return AppSettings(
        apiKey: apiKey,
        model: model,
        systemPrompt: systemPrompt,
        temperature: temperature,
        thinkingLevel: thinkingLevel,
        wakeWordSensitivity: wakeWordSensitivity,
        aodClockStyle: aodClockStyle,
        aodScrollSpeedSeconds: aodScrollSpeed,
        isFirstRun: isFirstRun,
        language: language,
      );
    } catch (e) {
      _logger.e('[Settings] Failed to load: $e');
      throw StorageException('Failed to load settings: $e');
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_keyApiKey, settings.apiKey),
        prefs.setString(_keyModel, settings.model),
        prefs.setString(_keySystemPrompt, settings.systemPrompt),
        prefs.setDouble(_keyTemperature, settings.temperature),
        prefs.setString(_keyThinkingLevel, settings.thinkingLevel.name),
        prefs.setDouble(_keyWakeWordSensitivity, settings.wakeWordSensitivity),
        prefs.setString(_keyAodClockStyle, settings.aodClockStyle.name),
        prefs.setInt(_keyAodScrollSpeed, settings.aodScrollSpeedSeconds),
        prefs.setBool(_keyIsFirstRun, settings.isFirstRun),
        prefs.setString(_keyLanguage, settings.language.name),
      ]);
      _logger.i('[Settings] Saved successfully');
    } catch (e) {
      _logger.e('[Settings] Failed to save: $e');
      throw StorageException('Failed to save settings: $e');
    }
  }

  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
