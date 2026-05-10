import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';
import '../../domain/entities/dhikr.dart';
import '../providers/dhikr_provider.dart';

class DhikrCounterScreen extends ConsumerStatefulWidget {
  final Dhikr dhikr;
  const DhikrCounterScreen({super.key, required this.dhikr});

  @override
  ConsumerState<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends ConsumerState<DhikrCounterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isCompleted) return;

    ref.read(dhikrProvider.notifier).incrementCount(widget.dhikr.id);
    _controller.forward(from: 0);
    HapticFeedback.lightImpact();
    Vibration.vibrate(duration: 50);

    final currentDhikr = ref.read(dhikrProvider).dhikrs.firstWhere((d) => d.id == widget.dhikr.id);
    if (currentDhikr.currentCount >= widget.dhikr.targetCount && !_isCompleted) {
      setState(() {
        _isCompleted = true;
      });
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final theme = Theme.of(context);
    Vibration.vibrate(pattern: [0, 200, 100, 200]);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            Text(
              'মাশাআল্লাহ! আলহামদুলিল্লাহ',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'আপনি সফলভাবে ${widget.dhikr.title} শেষ করেছেন।',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('ঠিক আছে'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dhikrState = ref.watch(dhikrProvider);
    final currentDhikr = dhikrState.dhikrs.firstWhere(
      (d) => d.id == widget.dhikr.id,
      orElse: () => widget.dhikr,
    );
    final progress = currentDhikr.currentCount / currentDhikr.targetCount;

    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark 
                ? [theme.colorScheme.surface, theme.colorScheme.surface]
                : [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh, color: theme.colorScheme.onPrimary),
                      onPressed: () => ref.read(dhikrProvider.notifier).resetCount(widget.dhikr.id),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  widget.dhikr.arabic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: theme.colorScheme.onPrimary,
                    fontFamily: 'Noto Naskh Arabic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.dhikr.bangla,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.dhikr.healthBenefit,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(
                        value: progress.clamp(0, 1),
                        strokeWidth: 12,
                        backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                        color: isDark ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.2).animate(
                            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                          ),
                          child: Text(
                            '${currentDhikr.currentCount}',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '/ ${widget.dhikr.targetCount}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'যেকোনো জায়গায় tap করুন',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
