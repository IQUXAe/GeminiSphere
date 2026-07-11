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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w400)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () {
                context.read<SettingsBloc>().add(const ResetSettingsEvent());
                setState(() => _initialized = false);
              },
              child: const Text('Reset', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            _buildSectionHeader('API CONFIGURATION'),
            _buildListTile(
              'Gemini API Key',
              subtitle: 'Required for voice features',
              trailing: _buildTextField(_apiKeyController, obscure: true, hint: 'AIza...'),
            ),
            _buildDivider(),
            _buildListTile(
              'Model',
              trailing: _buildTextField(_modelController, hint: 'gemini-2.0-flash-live-001'),
            ),
            
            const SizedBox(height: 32),
            _buildSectionHeader('AI BEHAVIOR'),
            _buildListTile(
              'System Prompt',
              subtitle: 'Instructions for the AI persona',
              onTap: () => _showPromptDialog(),
            ),
            _buildDivider(),
            _buildListTile(
              'Temperature',
              subtitle: _temperature.toStringAsFixed(1),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _temperature,
                  min: 0.0,
                  max: 2.0,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  onChanged: (v) => setState(() => _temperature = double.parse(v.toStringAsFixed(1))),
                ),
              ),
            ),
            _buildDivider(),
            _buildDropdownTile<ThinkingLevel>(
              'Thinking Level',
              _thinkingLevel,
              ThinkingLevel.values,
              (v) => setState(() => _thinkingLevel = v!),
              labels: {'none': 'None', 'low': 'Low', 'medium': 'Medium', 'high': 'High'},
            ),
            _buildDivider(),
            _buildDropdownTile<AppLanguage>(
              'Language',
              _language,
              AppLanguage.values,
              (v) => setState(() => _language = v!),
              labels: {'auto': 'Auto', 'ru': 'Russian', 'en': 'English'},
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('WAKE WORD'),
            _buildListTile(
              'Trigger Phrase',
              subtitle: 'Say "Gemini"',
            ),
            _buildDivider(),
            _buildListTile(
              'Sensitivity',
              subtitle: _wakeWordSensitivity.toStringAsFixed(2),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _wakeWordSensitivity,
                  min: 0.1,
                  max: 1.0,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  onChanged: (v) => setState(() => _wakeWordSensitivity = double.parse(v.toStringAsFixed(2))),
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader('ALWAYS-ON DISPLAY'),
            _buildDropdownTile<AodClockStyle>(
              'Clock Style',
              _aodClockStyle,
              AodClockStyle.values,
              (v) => setState(() => _aodClockStyle = v!),
            ),
            _buildDivider(),
            _buildListTile(
              'Drift Speed',
              subtitle: '${_aodScrollSpeed}s',
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _aodScrollSpeed.toDouble(),
                  min: 10,
                  max: 120,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                  onChanged: (v) => setState(() => _aodScrollSpeed = v.round()),
                ),
              ),
            ),

            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text('System Prompt', style: TextStyle(color: Colors.white, fontSize: 18)),
        content: TextField(
          controller: _systemPromptController,
          maxLines: 8,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter persona instructions...',
            hintStyle: TextStyle(color: Colors.white30),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8, top: 16),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white12, height: 1, indent: 20);
  }

  Widget _buildListTile(String title, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 14)) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDropdownTile<T extends Enum>(String title, T value, List<T> items, ValueChanged<T?> onChanged, {Map<String, String>? labels}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
      trailing: DropdownButton<T>(
        value: value,
        dropdownColor: const Color(0xFF1C1C1E),
        style: const TextStyle(color: Colors.white70, fontSize: 16),
        underline: const SizedBox(),
        icon: const Icon(Icons.chevron_right, color: Colors.white38),
        items: items.map((v) => DropdownMenuItem(
          value: v,
          child: Text(labels?[v.name] ?? v.name),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {bool obscure = false, String? hint}) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textAlign: TextAlign.end,
        style: const TextStyle(color: Colors.white70, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
        ),
      ),
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
