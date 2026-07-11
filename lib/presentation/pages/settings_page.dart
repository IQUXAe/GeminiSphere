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
  bool _isSaving = false;

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

  void _save() {
    final s = AppSettings(
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
    _isSaving = true;
    context.read<SettingsBloc>().add(UpdateSettingsEvent(s));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (ctx, state) {
        if (state is SettingsLoaded) {
          _initFromSettings(state.settings);
          if (_isSaving) {
            _isSaving = false;
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text('Settings saved'),
                backgroundColor: AppColors.primary,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w400)),
          backgroundColor: AppColors.background,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset to defaults',
              onPressed: () {
                context.read<SettingsBloc>().add(const ResetSettingsEvent());
                setState(() => _initialized = false);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('API Configuration'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _apiKeyController,
                      obscureText: !_showApiKey,
                      decoration: InputDecoration(
                        labelText: 'Gemini API Key',
                        hintText: 'Enter AIza... key',
                        suffixIcon: IconButton(
                          icon: Icon(_showApiKey ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _showApiKey = !_showApiKey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _modelController,
                      decoration: const InputDecoration(
                        labelText: 'Model',
                        hintText: 'gemini-2.0-flash-live-001',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('AI Behavior'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _systemPromptController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'System Prompt',
                        hintText: 'Instructions for the AI persona...',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSliderRow(
                      title: 'Temperature',
                      value: _temperature,
                      min: 0.0,
                      max: 2.0,
                      divisions: 20,
                      label: _temperature.toStringAsFixed(1),
                      onChanged: (v) => setState(() => _temperature = double.parse(v.toStringAsFixed(1))),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ThinkingLevel>(
                      value: _thinkingLevel,
                      decoration: const InputDecoration(labelText: 'Thinking Level'),
                      dropdownColor: AppColors.surfaceElevated,
                      items: ThinkingLevel.values.map((v) {
                        final label = {'none': 'None', 'low': 'Low', 'medium': 'Medium', 'high': 'High'}[v.name] ?? v.name;
                        return DropdownMenuItem(value: v, child: Text(label));
                      }).toList(),
                      onChanged: (v) => setState(() => _thinkingLevel = v!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<AppLanguage>(
                      value: _language,
                      decoration: const InputDecoration(labelText: 'Language'),
                      dropdownColor: AppColors.surfaceElevated,
                      items: AppLanguage.values.map((v) {
                        final label = {'auto': 'Auto', 'ru': 'Russian', 'en': 'English'}[v.name] ?? v.name;
                        return DropdownMenuItem(value: v, child: Text(label));
                      }).toList(),
                      onChanged: (v) => setState(() => _language = v!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Wake Word'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'Trigger Phrase: "Gemini" / "Джемини"',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSliderRow(
                      title: 'Sensitivity',
                      value: _wakeWordSensitivity,
                      min: 0.1,
                      max: 1.0,
                      divisions: 18,
                      label: _wakeWordSensitivity.toStringAsFixed(2),
                      onChanged: (v) => setState(() => _wakeWordSensitivity = double.parse(v.toStringAsFixed(2))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Always-On Display'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<AodClockStyle>(
                      value: _aodClockStyle,
                      decoration: const InputDecoration(labelText: 'Clock Style'),
                      dropdownColor: AppColors.surfaceElevated,
                      items: AodClockStyle.values.map((v) {
                        final label = v.name[0].toUpperCase() + v.name.substring(1);
                        return DropdownMenuItem(value: v, child: Text(label));
                      }).toList(),
                      onChanged: (v) => setState(() => _aodClockStyle = v!),
                    ),
                    const SizedBox(height: 20),
                    _buildSliderRow(
                      title: 'Drift Speed',
                      value: _aodScrollSpeed.toDouble(),
                      min: 10,
                      max: 120,
                      divisions: 22,
                      label: '${_aodScrollSpeed}s',
                      onChanged: (v) => setState(() => _aodScrollSpeed = v.round()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primaryLight,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _modelController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }
}
