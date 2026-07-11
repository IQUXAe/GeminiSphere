import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/app_settings.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_event.dart';
import '../blocs/settings/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _apiKeyController;
  late TextEditingController _modelController;
  late TextEditingController _systemPromptController;
  double _temperature = 1.0;
  ThinkingLevel _thinkingLevel = ThinkingLevel.low;
  double _wakeWordSensitivity = 0.6;
  AodClockStyle _aodClockStyle = AodClockStyle.digital;
  int _aodScrollSpeed = 30;
  AppLanguage _language = AppLanguage.auto;
  bool _showApiKey = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
    _modelController = TextEditingController();
    _systemPromptController = TextEditingController();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  void _initFromSettings(AppSettings s) {
    if (_initialized) return;
    _initialized = true;
    _apiKeyController.text = s.apiKey;
    _modelController.text = s.model;
    _systemPromptController.text = s.systemPrompt;
    setState(() {
      _temperature = s.temperature;
      _thinkingLevel = s.thinkingLevel;
      _wakeWordSensitivity = s.wakeWordSensitivity;
      _aodClockStyle = s.aodClockStyle;
      _aodScrollSpeed = s.aodScrollSpeedSeconds;
      _language = s.language;
    });
  }

  AppSettings _buildSettings() => AppSettings(
    apiKey: _apiKeyController.text.trim(),
    model: _modelController.text.trim().isEmpty ? 'gemini-2.0-flash-live-001' : _modelController.text.trim(),
    systemPrompt: _systemPromptController.text.trim(),
    temperature: _temperature,
    thinkingLevel: _thinkingLevel,
    wakeWordSensitivity: _wakeWordSensitivity,
    aodClockStyle: _aodClockStyle,
    aodScrollSpeedSeconds: _aodScrollSpeed,
    language: _language,
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (ctx, state) {
        if (state is SettingsLoaded) _initFromSettings(state.settings);
        if (state is SettingsSaved) {
          _initFromSettings(state.settings);
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Settings saved!'),
              backgroundColor: AppColors.secondary,
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is SettingsError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                context.read<SettingsBloc>().add(const ResetSettingsEvent());
                setState(() => _initialized = false);
              },
              child: const Text('Reset', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('API Configuration'),
              _card([
                _apiKeyField(),
                const SizedBox(height: 16),
                _textField('Model', _modelController, hint: 'gemini-2.0-flash-live-001'),
              ]),
              _sectionHeader('AI Behavior'),
              _card([
                _systemPromptField(),
                const SizedBox(height: 20),
                _slider('Temperature', _temperature, 0.0, 2.0, (v) => setState(() => _temperature = double.parse(v.toStringAsFixed(1))),
                    label: _temperature.toStringAsFixed(1)),
                const SizedBox(height: 16),
                _dropdown<ThinkingLevel>(
                  'Thinking Level',
                  _thinkingLevel,
                  ThinkingLevel.values,
                  (v) => setState(() => _thinkingLevel = v!),
                  labels: {'none': 'None (fastest)', 'low': 'Low', 'medium': 'Medium', 'high': 'High (deepest)'},
                ),
                const SizedBox(height: 16),
                _dropdown<AppLanguage>(
                  'Language',
                  _language,
                  AppLanguage.values,
                  (v) => setState(() => _language = v!),
                  labels: {'auto': 'Auto-detect', 'ru': 'Russian', 'en': 'English'},
                ),
              ]),
              _sectionHeader('Wake Word'),
              _card([
                Row(
                  children: [
                    const Icon(Icons.mic, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    const Text('Trigger: say "Gemini"', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                _slider('Sensitivity', _wakeWordSensitivity, 0.1, 1.0,
                    (v) => setState(() => _wakeWordSensitivity = double.parse(v.toStringAsFixed(2))),
                    label: _wakeWordSensitivity.toStringAsFixed(2)),
              ]),
              _sectionHeader('Always-On Display'),
              _card([
                const Text('Clock Style', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: AodClockStyle.values.map((style) => Expanded(
                    child: RadioListTile<AodClockStyle>(
                      title: Text(style.name, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                      value: style,
                      groupValue: _aodClockStyle,
                      onChanged: (v) => setState(() => _aodClockStyle = v!),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                _slider(
                  'Drift Speed (${_aodScrollSpeed}s)',
                  _aodScrollSpeed.toDouble(), 10, 120,
                  (v) => setState(() => _aodScrollSpeed = v.round()),
                ),
              ]),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => context.read<SettingsBloc>().add(UpdateSettingsEvent(_buildSettings())),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Settings', style: TextStyle(fontSize: 16, letterSpacing: 1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _apiKeyField() => TextField(
    controller: _apiKeyController,
    obscureText: !_showApiKey,
    style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'monospace'),
    decoration: InputDecoration(
      labelText: 'Gemini API Key',
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintText: 'AIza...',
      hintStyle: const TextStyle(color: AppColors.textDim),
      suffixIcon: IconButton(
        icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility, color: AppColors.textDim),
        onPressed: () => setState(() => _showApiKey = !_showApiKey),
      ),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textDim)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
    ),
  );

  Widget _textField(String label, TextEditingController controller, {String? hint}) => TextField(
    controller: controller,
    style: const TextStyle(color: AppColors.textPrimary),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textDim),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textDim)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
    ),
  );

  Widget _systemPromptField() => TextField(
    controller: _systemPromptController,
    maxLines: 5,
    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
    decoration: InputDecoration(
      labelText: 'System Prompt',
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      alignLabelWithHint: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.textDim),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.textDim),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),
  );

  Widget _slider(String label, double value, double min, double max, ValueChanged<double> onChanged, {String? label2}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          if (label2 != null)
            Text(label2, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        ],
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.surfaceElevated,
      ),
    ],
  );

  Widget _dropdown<T extends Enum>(String label, T value, List<T> values, ValueChanged<T?> onChanged, {Map<String, String>? labels}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      const SizedBox(height: 4),
      DropdownButton<T>(
        value: value,
        isExpanded: true,
        dropdownColor: AppColors.surfaceElevated,
        style: const TextStyle(color: AppColors.textPrimary),
        underline: const Divider(color: AppColors.textDim, height: 1),
        items: values.map((v) => DropdownMenuItem(
          value: v,
          child: Text(labels?[v.name] ?? v.name),
        )).toList(),
        onChanged: onChanged,
      ),
    ],
  );

  @override
  void dispose() {
    _apiKeyController.dispose();
    _modelController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }
}
