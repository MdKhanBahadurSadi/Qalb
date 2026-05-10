import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/prayer_card.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);
    final countdown = ref.watch(prayerCountdownProvider).value ?? '--:--:--';
    final currentPrayer = ref.watch(currentPrayerStatusProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.background,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: prayerTimesAsync.when(
            data: (prayers) {
              final nextPrayer = prayers.firstWhere((p) => p.isNext, orElse: () => prayers.first);
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, theme, nextPrayer, countdown),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final prayer = prayers[index];
                          final isCurrent = currentPrayer?['name'] == prayer.name;
                          return PrayerCard(
                            prayer: prayer,
                            isCurrent: isCurrent,
                          );
                        },
                        childCount: prayers.length,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
            error: (err, stack) => _buildErrorState(ref, theme, err.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme, nextPrayer, String countdown) {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      foregroundColor: theme.colorScheme.onPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nextPrayer.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              countdown,
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Text(
              'পরবর্তী নামাজের বাকি',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: theme.colorScheme.onPrimary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'লাইভ লোকেশন',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(locationProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      ),
    );
  }
}
