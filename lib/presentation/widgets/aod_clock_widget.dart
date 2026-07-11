import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/app_settings.dart';

class AodClockWidget extends StatefulWidget {
  final AodClockStyle style;
  final int scrollSpeedSeconds;

  const AodClockWidget({
    super.key,
    this.style = AodClockStyle.digital,
    this.scrollSpeedSeconds = 30,
  });

  @override
  State<AodClockWidget> createState() => _AodClockWidgetState();
}

class _AodClockWidgetState extends State<AodClockWidget>
    with SingleTickerProviderStateMixin {
  late Timer _clockTimer;
  late AnimationController _driftController;
  late Animation<Offset> _driftAnim;
  DateTime _now = DateTime.now();
  Offset _currentTarget = const Offset(0, 0);
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Update clock every second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });

    // Drift controller
    _driftController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.scrollSpeedSeconds),
    );

    // Initialize with a dummy animation before scheduling the first drift
    _driftAnim = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(_driftController);

    _scheduleNextDrift();
  }

  void _scheduleNextDrift() {
    final newTarget = Offset(
      _random.nextDouble() * 0.08 - 0.04, // ±4% of screen width
      _random.nextDouble() * 0.08 - 0.04, // ±4% of screen height
    );

    _driftAnim = Tween<Offset>(
      begin: _currentTarget,
      end: newTarget,
    ).animate(CurvedAnimation(
      parent: _driftController,
      curve: Curves.easeInOut,
    ));

    _currentTarget = newTarget;
    _driftController.forward(from: 0).then((_) {
      if (mounted) _scheduleNextDrift();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _driftAnim,
      builder: (context, child) {
        final offset = _driftAnim.value;
        return Transform.translate(
          offset: Offset(offset.dx * size.width, offset.dy * size.height),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTimeText(),
          const SizedBox(height: 8),
          _buildDateText(),
        ],
      ),
    );
  }

  Widget _buildTimeText() {
    final timeStr = DateFormat('HH:mm').format(_now);
    switch (widget.style) {
      case AodClockStyle.digital:
        return Text(
          timeStr,
          style: const TextStyle(
            fontFamily: 'DigitalClock',
            fontSize: 72,
            color: AppColors.aodClock,
            letterSpacing: 4,
            fontWeight: FontWeight.w100,
          ),
        );
      case AodClockStyle.minimal:
        return Text(
          timeStr,
          style: const TextStyle(
            fontSize: 64,
            color: AppColors.aodClock,
            fontWeight: FontWeight.w100,
            letterSpacing: 2,
          ),
        );
      case AodClockStyle.outlined:
        return Text(
          timeStr,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w200,
            letterSpacing: 4,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5
              ..color = AppColors.aodClock,
          ),
        );
    }
  }

  Widget _buildDateText() {
    final dateStr = DateFormat('EEE, d MMM').format(_now);
    return Text(
      dateStr,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textDim,
        letterSpacing: 2,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _driftController.dispose();
    super.dispose();
  }
}
