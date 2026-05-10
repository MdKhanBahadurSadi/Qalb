import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<Color?> _colorAnimation;

  int _round = 1;
  int _countdown = 4;
  String _phase = 'শ্বাস নিন';
  bool _isCompleted = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    _radiusAnimation = Tween<double>(begin: 80, end: 160).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF4DB6AC), // Warm Teal
      end: const Color(0xFF64B5F6),   // Cool Blue
    ).animate(_controller);

    _startExercise();
  }

  void _startExercise() {
    _inhale();
  }

  void _inhale() {
    if (!mounted) return;
    setState(() {
      _phase = 'শ্বাস নিন';
      _countdown = 4;
    });
    _controller.duration = const Duration(seconds: 4);
    _controller.forward();
    _startTimer(4, _hold);
  }

  void _hold() {
    if (!mounted) return;
    setState(() {
      _phase = 'ধরে রাখুন';
      _countdown = 7;
    });
    _startTimer(7, _exhale);
  }

  void _exhale() {
    if (!mounted) return;
    setState(() {
      _phase = 'ছেড়ে দিন';
      _countdown = 8;
    });
    _controller.duration = const Duration(seconds: 8);
    _controller.reverse();
    _startTimer(8, () {
      if (_round < 4) {
        setState(() => _round++);
        _inhale();
      } else {
        setState(() => _isCompleted = true);
      }
    });
  }

  void _startTimer(int seconds, VoidCallback onComplete) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (_isCompleted) return _buildCompletionScreen(theme);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
              ? [theme.colorScheme.surface, theme.colorScheme.background]
              : [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildRoundIndicator(theme),
              const Spacer(),
              _buildBreathingCircle(),
              const SizedBox(height: 60),
              Text(
                _phase,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _countdown.toString(),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: (isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary).withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'অনুশীলন বন্ধ করুন', 
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: (isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary).withValues(alpha: 0.5)
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundIndicator(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? theme.colorScheme.primary : const Color(0xFF4DB6AC);
    final inactiveColor = (isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary).withValues(alpha: 0.24);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isAchieved = index < _round;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isAchieved ? activeColor : inactiveColor,
            shape: BoxShape.circle,
            boxShadow: isAchieved ? [BoxShadow(color: activeColor, blurRadius: 8)] : null,
          ),
        );
      }),
    );
  }

  Widget _buildBreathingCircle() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: 320,
          height: 320,
          child: CustomPaint(
            painter: _BreathingPainter(
              radius: _radiusAnimation.value,
              color: _colorAnimation.value ?? const Color(0xFF4DB6AC),
              isPulsing: _phase == 'ধরে রাখুন',
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletionScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 100),
              const SizedBox(height: 30),
              Text(
                'মাশাআল্লাহ! আপনি সফল হয়েছেন 🌿',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'ক্র্যাভিং কাটিয়ে উঠুন — আল্লাহ আপনার সাথে',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('ফিরে যান'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathingPainter extends CustomPainter {
  final double radius;
  final Color color;
  final bool isPulsing;

  _BreathingPainter({required this.radius, required this.color, required this.isPulsing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Layered glow effect
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.1 * (4 - i))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 * i);
      canvas.drawCircle(center, radius + (5 * i), glowPaint);
    }

    // Main circle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Inner detail - Using theme-agnostic light highlight
    final detailPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withValues(alpha: 0.4), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius * 0.8, detailPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathingPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
