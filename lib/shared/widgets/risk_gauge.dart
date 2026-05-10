import 'dart:math' as math;
import 'package:flutter/material.dart';

class RiskGauge extends StatelessWidget {
  final double score;
  final double size;
  final bool animate;

  const RiskGauge({
    super.key,
    required this.score,
    this.size = 200,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: animate ? 1500 : 0),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: score),
      builder: (context, value, child) {
        final statusColor = _getColor(value);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(
                  score: value,
                  primaryColor: statusColor,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value.toInt()}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: size * 0.2,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    _getLabel(value),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: size * 0.08,
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColor(double score) {
    if (score < 30) return Colors.green;
    if (score < 60) return Colors.orange;
    return Colors.red;
  }

  String _getLabel(double score) {
    if (score < 30) return 'কম ঝুঁকি';
    if (score < 60) return 'মাঝারি ঝুঁকি';
    return 'উচ্চ ঝুঁকি';
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color primaryColor;
  final Color backgroundColor;

  _GaugePainter({
    required this.score,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.1;

    // Background Arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      bgPaint,
    );

    // Progress Arc
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.75,
      (math.pi * 1.5) * (score / 100).clamp(0.0, 1.0),
      false,
      progressPaint,
    );

    // Subtle Glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      math.pi * 0.75,
      (math.pi * 1.5) * (score / 100).clamp(0.0, 1.0),
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.score != score;
}
