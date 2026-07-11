import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/session/session_state.dart';

class SphereAnimationWidget extends StatefulWidget {
  final SessionPhase phase;
  final double amplitude; // 0.0 - 1.0

  const SphereAnimationWidget({
    super.key,
    required this.phase,
    this.amplitude = 0.0,
  });

  @override
  State<SphereAnimationWidget> createState() => _SphereAnimationWidgetState();
}

class _SphereAnimationWidgetState extends State<SphereAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _colorController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SphereAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) {
      _updateAnimationSpeed();
    }
  }

  void _updateAnimationSpeed() {
    switch (widget.phase) {
      case SessionPhase.listening:
        _waveController.duration = const Duration(seconds: 8);
        break;
      case SessionPhase.speaking:
        _waveController.duration = const Duration(seconds: 3);
        break;
      case SessionPhase.connecting:
      case SessionPhase.toolCalling:
        _waveController.duration = const Duration(seconds: 6);
        break;
      default:
        _waveController.duration = const Duration(seconds: 15);
    }
    if (_waveController.isAnimating) {
      _waveController.repeat();
    }
  }

  (Color, Color, Color) get _gradientColors {
    switch (widget.phase) {
      case SessionPhase.listening:
        return (AppColors.sphereListeningStart, AppColors.sphereListeningEnd, Colors.deepPurple);
      case SessionPhase.speaking:
        return (AppColors.sphereSpeakingStart, AppColors.sphereSpeakingEnd, Colors.cyan);
      case SessionPhase.connecting:
      case SessionPhase.toolCalling:
        return (AppColors.primary, AppColors.primaryLight, Colors.indigo);
      case SessionPhase.error:
        return (AppColors.error, Colors.redAccent, Colors.deepOrange);
      case SessionPhase.idle:
      default:
        return (Colors.black, const Color(0xFF0D0D1A), const Color(0xFF151525));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color1, color2, color3) = _gradientColors;

    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _colorController]),
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _AuroraPainter(
            time: _waveController.value * 2 * pi,
            colorPhase: _colorController.value,
            amplitude: widget.amplitude,
            color1: color1,
            color2: color2,
            color3: color3,
            isActive: widget.phase != SessionPhase.idle,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _colorController.dispose();
    super.dispose();
  }
}

class _AuroraPainter extends CustomPainter {
  final double time;
  final double colorPhase;
  final double amplitude;
  final Color color1;
  final Color color2;
  final Color color3;
  final bool isActive;

  const _AuroraPainter({
    required this.time,
    required this.colorPhase,
    required this.amplitude,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, bgPaint);

    if (!isActive) return; // Completely black when idle, or very subtle

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.longestSide * 0.8;

    // We draw 3 overlapping fluid blobs with MaskFilter.blur for the Aurora effect
    _drawBlob(
      canvas,
      center,
      maxRadius * (0.5 + amplitude * 0.3),
      time,
      color1.withOpacity(0.4 + colorPhase * 0.2),
      Offset(sin(time) * size.width * 0.2, cos(time) * size.height * 0.2),
    );

    _drawBlob(
      canvas,
      center,
      maxRadius * (0.6 + amplitude * 0.4),
      time + pi * 0.6,
      color2.withOpacity(0.5 - colorPhase * 0.2),
      Offset(cos(time * 1.3) * size.width * 0.3, sin(time * 0.8) * size.height * 0.2),
    );

    _drawBlob(
      canvas,
      center,
      maxRadius * (0.4 + amplitude * 0.5),
      time + pi * 1.2,
      color3.withOpacity(0.4),
      Offset(sin(time * 0.7) * size.width * 0.1, cos(time * 1.1) * size.height * 0.3),
    );
  }

  void _drawBlob(Canvas canvas, Offset center, double radius, double phase, Color color, Offset drift) {
    final path = Path();
    const points = 6;
    final angleStep = 2 * pi / points;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep;
      // Organic distortion
      final wave = 1.0 + sin(phase + i * 1.5) * 0.2 + cos(phase * 1.2 + i) * 0.15;
      final r = radius * wave;
      final x = center.dx + drift.dx + r * cos(angle + phase * 0.2);
      final y = center.dy + drift.dy + r * sin(angle + phase * 0.2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Curve to next point
        final prevAngle = (i - 1) * angleStep;
        final prevWave = 1.0 + sin(phase + (i - 1) * 1.5) * 0.2 + cos(phase * 1.2 + (i - 1)) * 0.15;
        final prevR = radius * prevWave;
        final prevX = center.dx + drift.dx + prevR * cos(prevAngle + phase * 0.2);
        final prevY = center.dy + drift.dy + prevR * sin(prevAngle + phase * 0.2);

        final cpX = (prevX + x) / 2 + sin(phase + i) * radius * 0.2;
        final cpY = (prevY + y) / 2 + cos(phase + i) * radius * 0.2;
        path.quadraticBezierTo(cpX, cpY, x, y);
      }
    }
    
    // Close smoothly
    final firstAngle = 0.0;
    final firstWave = 1.0 + sin(phase) * 0.2 + cos(phase * 1.2) * 0.15;
    final firstR = radius * firstWave;
    final firstX = center.dx + drift.dx + firstR * cos(firstAngle + phase * 0.2);
    final firstY = center.dy + drift.dy + firstR * sin(firstAngle + phase * 0.2);
    
    final lastAngle = (points - 1) * angleStep;
    final lastWave = 1.0 + sin(phase + (points - 1) * 1.5) * 0.2 + cos(phase * 1.2 + (points - 1)) * 0.15;
    final lastR = radius * lastWave;
    final lastX = center.dx + drift.dx + lastR * cos(lastAngle + phase * 0.2);
    final lastY = center.dy + drift.dy + lastR * sin(lastAngle + phase * 0.2);

    final cpX = (lastX + firstX) / 2 + sin(phase) * radius * 0.2;
    final cpY = (lastY + firstY) / 2 + cos(phase) * radius * 0.2;
    path.quadraticBezierTo(cpX, cpY, firstX, firstY);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.4); // Huge blur for fluid effect

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.time != time ||
      old.colorPhase != colorPhase ||
      old.amplitude != amplitude ||
      old.isActive != isActive ||
      old.color1 != color1;
}
