import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/session/session_state.dart';

class SphereAnimationWidget extends StatefulWidget {
  final SessionPhase phase;
  final double amplitude; // 0.0 - 1.0, from PCM RMS

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
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _blobController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(SphereAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationSpeed();
  }

  void _updateAnimationSpeed() {
    switch (widget.phase) {
      case SessionPhase.listening:
        _pulseController.duration = const Duration(milliseconds: 1200);
        break;
      case SessionPhase.speaking:
        _pulseController.duration = const Duration(milliseconds: 400);
        break;
      case SessionPhase.connecting:
        _pulseController.duration = const Duration(milliseconds: 800);
        break;
      default:
        _pulseController.duration = const Duration(milliseconds: 2500);
    }
  }

  (Color, Color) get _gradientColors {
    switch (widget.phase) {
      case SessionPhase.listening:
        return (AppColors.sphereListeningStart, AppColors.sphereListeningEnd);
      case SessionPhase.speaking:
        return (AppColors.sphereSpeakingStart, AppColors.sphereSpeakingEnd);
      case SessionPhase.connecting:
        return (AppColors.primary, AppColors.primaryLight);
      case SessionPhase.toolCalling:
        return (AppColors.secondary, AppColors.secondaryLight);
      case SessionPhase.error:
        return (AppColors.error, Colors.redAccent);
      case SessionPhase.idle:
        return (AppColors.sphereIdleColor, AppColors.sphereIdleColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (startColor, endColor) = _gradientColors;
    final sphereSize = MediaQuery.of(context).size.shortestSide * 0.55;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _rotationController, _blobController]),
      builder: (context, child) {
        final scale = _pulseAnim.value + widget.amplitude * 0.15;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow rings
            if (widget.phase != SessionPhase.idle) ..._buildGlowRings(sphereSize, startColor),
            // Main sphere
            Transform.scale(
              scale: scale,
              child: CustomPaint(
                size: Size(sphereSize, sphereSize),
                painter: _SpherePainter(
                  startColor: startColor,
                  endColor: endColor,
                  rotation: _rotationController.value,
                  blobOffset: _blobController.value,
                  amplitude: widget.amplitude,
                ),
              ),
            ),
            // Center icon/text
            _buildCenterContent(),
          ],
        );
      },
    );
  }

  List<Widget> _buildGlowRings(double sphereSize, Color color) {
    return [
      Opacity(
        opacity: 0.08 + widget.amplitude * 0.12,
        child: Container(
          width: sphereSize * 1.6,
          height: sphereSize * 1.6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(0.3), Colors.transparent],
            ),
          ),
        ),
      ),
      Opacity(
        opacity: 0.12 + widget.amplitude * 0.08,
        child: Container(
          width: sphereSize * 1.25,
          height: sphereSize * 1.25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCenterContent() {
    switch (widget.phase) {
      case SessionPhase.listening:
        return const Icon(Icons.mic, color: Colors.white, size: 32)
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 1.0, end: 1.2, duration: 600.ms, curve: Curves.easeInOut)
            .then()
            .scaleXY(begin: 1.2, end: 1.0, duration: 600.ms);
      case SessionPhase.speaking:
        return const Icon(Icons.volume_up, color: Colors.white, size: 32)
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 1.0, end: 1.15, duration: 300.ms)
            .then()
            .scaleXY(begin: 1.15, end: 1.0, duration: 300.ms);
      case SessionPhase.connecting:
        return const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        );
      case SessionPhase.toolCalling:
        return const Icon(Icons.settings, color: Colors.white, size: 28)
            .animate(onPlay: (c) => c.repeat())
            .rotate(duration: 1000.ms);
      case SessionPhase.error:
        return const Icon(Icons.error_outline, color: Colors.white, size: 32);
      case SessionPhase.idle:
        return Icon(Icons.graphic_eq, color: AppColors.textDim, size: 28);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _blobController.dispose();
    super.dispose();
  }
}

class _SpherePainter extends CustomPainter {
  final Color startColor;
  final Color endColor;
  final double rotation;
  final double blobOffset;
  final double amplitude;

  const _SpherePainter({
    required this.startColor,
    required this.endColor,
    required this.rotation,
    required this.blobOffset,
    required this.amplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the organic blob shape
    final path = _buildBlobPath(center, radius);

    // Gradient fill
    final gradient = RadialGradient(
      center: Alignment(
        -0.3 + sin(rotation * 2 * pi) * 0.3,
        -0.3 + cos(rotation * 2 * pi) * 0.3,
      ),
      radius: 1.0,
      colors: [startColor, endColor, startColor.withOpacity(0.6)],
      stops: const [0.0, 0.6, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Specular highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.25, -radius * 0.25),
        width: radius * 0.5,
        height: radius * 0.3,
      ),
      highlightPaint,
    );
  }

  Path _buildBlobPath(Offset center, double radius) {
    // Organic blob using bezier curves, animated with blobOffset and amplitude
    final path = Path();
    const points = 8;
    final angleStep = 2 * pi / points;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep + rotation * 2 * pi;
      final wave = 1.0 +
          sin(blobOffset * 2 * pi + i * 1.5) * (0.06 + amplitude * 0.08) +
          cos(rotation * 4 * pi + i * 0.8) * 0.04;
      final r = radius * wave;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_SpherePainter old) =>
      old.rotation != rotation ||
      old.blobOffset != blobOffset ||
      old.amplitude != amplitude ||
      old.startColor != startColor ||
      old.endColor != endColor;
}
