import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qalb/features/smoking/presentation/providers/smoking_provider.dart';
import 'package:qalb/features/smoking/domain/entities/health_milestone.dart';
import 'package:qalb/shared/widgets/scaffold_with_nav_bar.dart';

class SmokingDashboardScreen extends ConsumerStatefulWidget {
  const SmokingDashboardScreen({super.key});

  @override
  ConsumerState<SmokingDashboardScreen> createState() => _SmokingDashboardScreenState();
}

class _SmokingDashboardScreenState extends ConsumerState<SmokingDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(smokingProvider);
    final theme = Theme.of(context);
    final isActive = ref.watch(activeTabProvider) == 3;

    if (!profile.isInRecovery || profile.quitDate == null) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    final avoided = SmokingCalculations.getCigarettesAvoided(profile.quitDate, profile.cigarettesPerDay);
    final money = SmokingCalculations.getMoneySaved(avoided, profile.packagePrice);
    final heartRisk = SmokingCalculations.getHeartRiskReduction(profile.quitDate);
    final milestones = SmokingCalculations.getMilestones(profile.quitDate);
    
    final nextMilestone = milestones.firstWhere((m) => !m.isAchieved, orElse: () => milestones.last);
    final initialDuration = SmokingCalculations.getDuration(profile.quitDate);

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroCounter(
                quitDate: profile.quitDate!,
                isActive: isActive,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsGrid(
                    theme: theme,
                    avoided: avoided,
                    money: money,
                    heartRisk: heartRisk,
                    nextMilestoneDays: nextMilestone.timeAfterQuitting.inDays - initialDuration.inDays,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'আপনার স্বাস্থ্যর উন্নতি',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _MilestoneTimeline(
                    theme: theme,
                    quitDate: profile.quitDate!,
                    isActive: isActive,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCounter extends ConsumerWidget {
  final DateTime quitDate;
  final bool isActive;
  const _HeroCounter({required this.quitDate, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (isActive) {
      ref.watch(smokingTickerProvider);
    }
    
    final duration = SmokingCalculations.getDuration(quitDate);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            'আলহামদুলিল্লাহ!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আপনি ধূমপান মুক্ত আছেন',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimePart(theme: theme, value: duration.inDays.toString(), label: 'দিন'),
              _TimePart(theme: theme, value: (duration.inHours % 24).toString(), label: 'ঘণ্টা'),
              _TimePart(theme: theme, value: (duration.inMinutes % 60).toString(), label: 'মিনিট'),
              _TimePart(theme: theme, value: (duration.inSeconds % 60).toString(), label: 'সেকেন্ড'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimePart extends StatelessWidget {
  final ThemeData theme;
  final String value;
  final String label;
  const _TimePart({required this.theme, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            value.padLeft(2, '0'),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final ThemeData theme;
  final int avoided;
  final double money;
  final double heartRisk;
  final int nextMilestoneDays;

  const _StatsGrid({
    required this.theme,
    required this.avoided,
    required this.money,
    required this.heartRisk,
    required this.nextMilestoneDays,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                theme: theme,
                icon: Icons.smoke_free,
                title: 'সিগারেট এড়ানো',
                value: '$avoided টি',
                color: isDark ? Colors.greenAccent : Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                theme: theme,
                icon: Icons.account_balance_wallet,
                title: 'টাকা বাঁচানো',
                value: '৳${money.toStringAsFixed(0)}',
                color: isDark ? Colors.blueAccent : Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                theme: theme,
                icon: Icons.favorite,
                title: 'হার্ট রিস্ক কমেছে',
                value: '${heartRisk.toStringAsFixed(1)}%',
                color: isDark ? Colors.redAccent : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                theme: theme,
                icon: Icons.flag,
                title: 'পরবর্তী মাইলস্টোন',
                value: nextMilestoneDays <= 0 ? 'আজই' : '$nextMilestoneDays দিন',
                color: isDark ? Colors.orangeAccent : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final ThemeData theme;
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.theme, required this.icon, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title, 
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            value, 
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, 
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneTimeline extends ConsumerWidget {
  final ThemeData theme;
  final DateTime quitDate;
  final bool isActive;
  const _MilestoneTimeline({required this.theme, required this.quitDate, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isActive) {
      ref.watch(smokingTickerProvider);
    }

    final currentDuration = SmokingCalculations.getDuration(quitDate);
    final milestones = SmokingCalculations.getMilestones(quitDate);
    final isDark = theme.brightness == Brightness.dark;
    final achievedColor = isDark ? Colors.greenAccent : Colors.green;

    return Column(
      children: List.generate(milestones.length, (index) {
        final m = milestones[index];
        final isLast = index == milestones.length - 1;
        
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: m.isAchieved ? achievedColor : theme.colorScheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: m.isAchieved
                          ? Icon(Icons.check, size: 16, color: isDark ? Colors.black : Colors.white)
                          : null,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: m.isAchieved ? achievedColor : theme.colorScheme.surfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: m.isAchieved ? FontWeight.bold : FontWeight.normal,
                          color: m.isAchieved ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (m.isAchieved && m.achievedAt != null)
                        Text(
                          'অর্জিত: ${DateFormat('MMM dd, hh:mm a').format(m.achievedAt!)}',
                          style: TextStyle(fontSize: 12, color: achievedColor),
                        )
                      else
                        Text(
                          'বাকি: ${_formatRemaining(m.timeAfterQuitting - currentDuration)}',
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      if (!m.isAchieved && index > 0 && milestones[index - 1].isAchieved)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: currentDuration.inSeconds /
                                  m.timeAfterQuitting.inSeconds.clamp(1, double.maxFinite).toInt(),
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              color: theme.colorScheme.primary,
                              minHeight: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'শীঘ্রই';
    if (d.inDays > 0) return '${d.inDays} দিন';
    if (d.inHours > 0) return '${d.inHours} ঘণ্টা';
    return '${d.inMinutes} মিনিট';
  }
}
