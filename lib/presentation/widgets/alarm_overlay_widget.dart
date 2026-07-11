import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/entities/alarm_entity.dart';

class AlarmOverlayWidget extends StatefulWidget {
  final TimerEntity? firedTimer;
  final AlarmEntity? firedAlarm;
  final VoidCallback onDismiss;
  final VoidCallback? onSnooze; // null for timers (no snooze)

  const AlarmOverlayWidget({
    super.key,
    this.firedTimer,
    this.firedAlarm,
    required this.onDismiss,
    this.onSnooze,
  });

  @override
  State<AlarmOverlayWidget> createState() => _AlarmOverlayWidgetState();
}

class _AlarmOverlayWidgetState extends State<AlarmOverlayWidget> {
  late Timer _pulseTimer;
  bool _isPulsing = false;

  @override
  void initState() {
    super.initState();
    _pulseTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (mounted) setState(() => _isPulsing = !_isPulsing);
    });
  }

  String get _title {
    if (widget.firedTimer != null) return '\u23F0 Timer!';
    if (widget.firedAlarm != null) return '\u23F0 Alarm!';
    return 'Alert!';
  }

  String get _label {
    return widget.firedTimer?.label ?? widget.firedAlarm?.label ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.92),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: _isPulsing ? 120 : 100,
              height: _isPulsing ? 120 : 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isPulsing
                    ? AppColors.error.withOpacity(0.2)
                    : AppColors.error.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.error,
                  width: _isPulsing ? 3 : 2,
                ),
              ),
              child: const Icon(
                Icons.alarm,
                color: AppColors.error,
                size: 52,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _title,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(duration: 300.ms),
            if (_label.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _label,
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ],
            const SizedBox(height: 8),
            const Text(
              'Say "Gemini" to respond',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textDim,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.onSnooze != null)
                  OutlinedButton.icon(
                    onPressed: widget.onSnooze,
                    icon: const Icon(Icons.snooze),
                    label: const Text('Snooze 5m'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.textDim),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: widget.onDismiss,
                  icon: const Icon(Icons.stop),
                  label: const Text('Dismiss'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseTimer.cancel();
    super.dispose();
  }
}
