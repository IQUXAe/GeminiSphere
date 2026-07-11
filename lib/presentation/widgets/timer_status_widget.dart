import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/entities/alarm_entity.dart';

class TimerStatusWidget extends StatefulWidget {
  final List<TimerEntity> timers;
  final List<AlarmEntity> alarms;

  const TimerStatusWidget({
    super.key,
    required this.timers,
    required this.alarms,
  });

  @override
  State<TimerStatusWidget> createState() => _TimerStatusWidgetState();
}

class _TimerStatusWidgetState extends State<TimerStatusWidget> {
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (final timer in widget.timers) {
      items.add(_TimerItem(timer: timer));
    }
    for (final alarm in widget.alarms) {
      items.add(_AlarmItem(alarm: alarm));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }
}

class _TimerItem extends StatelessWidget {
  final TimerEntity timer;

  const _TimerItem({required this.timer});

  String _formatRemaining(int seconds) {
    if (seconds <= 0) return '0:00';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = timer.remainingSeconds;
    final progress = remaining / timer.durationSeconds;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.timer, color: AppColors.secondary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timer.label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatRemaining(remaining),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontVariations: [FontVariation('wght', 300)],
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmItem extends StatelessWidget {
  final AlarmEntity alarm;

  const _AlarmItem({required this.alarm});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.alarm, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              alarm.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            timeStr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
