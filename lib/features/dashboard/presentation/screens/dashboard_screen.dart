import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../islamic/presentation/providers/prayer_times_provider.dart';
import '../../../risk_prediction/domain/entities/risk_result.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: Text('অ্যাপ বন্ধ করবেন?', style: theme.textTheme.titleLarge),
            content: Text('আপনি কি নিশ্চিত যে আপনি অ্যাপ থেকে বের হতে চান?', style: theme.textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('না', style: TextStyle(color: theme.colorScheme.primary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('হ্যাঁ', style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
        );

        if (shouldExit ?? false) {
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: dashboardAsync.when(
          data: (data) => CustomScrollView(
            slivers: [
              _buildAppBar(context, theme, data.userName),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHealthSummary(context, theme, data.latestResult),
                    const SizedBox(height: 24),
                    _buildQuickActionGrid(context, theme),
                    const SizedBox(height: 24),
                    _buildPrayerTimeCard(context, theme, ref),
                    const SizedBox(height: 24),
                    _buildDailyHadithCard(context, theme),
                    const SizedBox(height: 24),
                    _buildHealthTipCard(context, theme),
                    const SizedBox(height: 100), // Padding for bottom nav
                  ]),
                ),
              ),
            ],
          ),
          loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
          error: (e, s) => Center(child: Text('ভুল হয়েছে: $e', style: theme.textTheme.bodyMedium)),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme, String userName) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আস-সালামু আলাইকুম,',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimary.withValues(alpha: 0.7)),
            ),
            Text(
              userName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, 
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, color: theme.colorScheme.onPrimary),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            child: Icon(Icons.person, color: theme.colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummary(BuildContext context, ThemeData theme, RiskResult? result) {
    if (result == null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [theme.colorScheme.secondary, theme.colorScheme.secondary.withValues(alpha: 0.8)],
            ),
          ),
          child: Column(
            children: [
              Icon(Icons.health_and_safety, color: theme.colorScheme.onSecondary, size: 48),
              const SizedBox(height: 12),
              Text(
                'আপনি কি আপনার হার্ট রিস্ক জানেন?',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.push('/health-form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onSecondary,
                  foregroundColor: theme.colorScheme.secondary,
                  elevation: 0,
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('আজই পরীক্ষা করুন'),
              ),
            ],
          ),
        ),
      );
    }

    final daysAgo = DateTime.now().difference(result.calculatedAt).inDays;
    final categoryColor = _getCategoryColor(result.category, theme.brightness == Brightness.dark);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: result.score / 100,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: categoryColor,
                    strokeWidth: 6,
                  ),
                ),
                Text(
                  '${result.score}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getCategoryText(result.category),
                      style: TextStyle(color: categoryColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'শেষ পরীক্ষা: ${daysAgo == 0 ? "আজ" : "$daysAgo দিন আগে"}',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.push('/health-form'),
              child: const Text('আপডেট'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionCard(context, theme, Icons.biotech, 'রিস্ক পরীক্ষা', 'AI এনালাইসিস', '/health-form', theme.colorScheme.primary)),
            const SizedBox(width: 12),
            Expanded(child: _buildActionCard(context, theme, Icons.smoke_free, 'ধূমপান মুক্তি', 'নতুন জীবন', '/home/smoking', theme.colorScheme.secondary)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildActionCard(context, theme, Icons.mosque, 'স্পিরিচুয়াল গাইড', 'সুন্নাহ স্বাস্থ্য', '/home/spiritual', Colors.teal)),
            const SizedBox(width: 12),
            Expanded(child: _buildActionCard(context, theme, Icons.bar_chart, 'রিপোর্ট', 'বিস্তারিত ইতিহাস', '/report', Colors.deepPurpleAccent)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, ThemeData theme, IconData icon, String title, String subtitle, String route, Color color) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.1)),
      ),
      color: color.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                subtitle, 
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeCard(BuildContext context, ThemeData theme, WidgetRef ref) {
    final currentPrayer = ref.watch(currentPrayerStatusProvider);
    final nextPrayer = ref.watch(nextPrayerStatusProvider);
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: prayerTimesAsync.when(
          data: (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPrayer != null ? 'বর্তমান: ${currentPrayer['name']}' : 'পরবর্তী নামাজ', 
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        nextPrayer?['name'] ?? '--', 
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        nextPrayer?['time'] ?? '--:--', 
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'বাকি আছে', 
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final countdown = ref.watch(prayerCountdownProvider).value ?? '--:--:--';
                      return Text(
                        countdown,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => context.go('/home/spiritual'),
                    child: Text(
                      'সব ওয়াক্ত', 
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          loading: () => Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
          )),
          error: (e, _) => Center(child: Text('লোডে সমস্যা', style: TextStyle(color: theme.colorScheme.error, fontSize: 12))),
        ),
      ),
    );
  }

  Widget _buildDailyHadithCard(BuildContext context, ThemeData theme) {
    final hadiths = [
      {
        'ar': 'نِعْمَتَانِ مَغْبُونٌ فِيْهِمَا كَثِيْرٌ مِنَ النَّاسِ: الصِّحَّةُ وَالْفَرَاغُ',
        'bn': 'দুটি নিয়ামত এমন রয়েছে যাতে অধিকাংশ মানুষ ক্ষতিগ্রস্ত; সুস্থতা এবং অবসর সময়।',
        'ref': 'সহীহ বুখারী: ৬৪১২'
      },
    ];
    final hadith = hadiths[DateTime.now().day % hadiths.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 16),
          Text(
            hadith['ar']!,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold, 
              height: 1.5,
              fontFamily: 'Noto Naskh Arabic',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hadith['bn']!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Text(
            hadith['ref']!, 
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTipCard(BuildContext context, ThemeData theme) {
    final tips = [
      'প্রতিদিন অন্তত ৩০ মিনিট দ্রুত হাঁটার অভ্যাস করুন।',
      'অতিরিক্ত লবণ পরিহার করুন, এটি হৃদরোগের ঝুঁকি বাড়ায়।',
      'পর্যাপ্ত ঘুম নিশ্চিত করুন, যা হৃদপিণ্ডকে সচল রাখে।',
    ];
    final tip = tips[DateTime.now().weekday % tips.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            radius: 18,
            child: Icon(Icons.lightbulb, color: theme.colorScheme.onPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'আজকের টিপস', 
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  tip, 
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryText(RiskCategory cat) {
    switch (cat) {
      case RiskCategory.low: return 'কম ঝুঁকি';
      case RiskCategory.moderate: return 'মাঝারি ঝুঁকি';
      case RiskCategory.high: return 'উচ্চ ঝুঁকি';
      case RiskCategory.veryHigh: return 'অত্যন্ত উচ্চ ঝুঁকি';
    }
  }

  Color _getCategoryColor(RiskCategory cat, bool isDark) {
    switch (cat) {
      case RiskCategory.low: return isDark ? Colors.greenAccent : Colors.green;
      case RiskCategory.moderate: return isDark ? Colors.orangeAccent : Colors.orange;
      case RiskCategory.high: return isDark ? Colors.deepOrangeAccent : Colors.deepOrange;
      case RiskCategory.veryHigh: return isDark ? Colors.redAccent : Colors.red;
    }
  }
}
