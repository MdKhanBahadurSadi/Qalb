import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fasting_provider.dart';

class FastingTrackerScreen extends ConsumerWidget {
  const FastingTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingState = ref.watch(fastingProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('রোজা ট্র্যাকার')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fasting Toggle Hero
            _buildFastingToggle(context, theme, ref, fastingState),
            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme, 
                    'বর্তমান স্ট্রিক', 
                    '${fastingState.streak} দিন', 
                    Icons.local_fire_department, 
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme, 
                    'মোট রোজা', 
                    '${fastingState.fastingHistory.length}টি', 
                    Icons.calendar_today, 
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Calendar View
            Text(
              'রোজার ইতিহাস', 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMiniCalendar(theme, fastingState.fastingHistory),
            const SizedBox(height: 32),

            // Health Benefits
            _buildHealthBenefitsSection(theme),
            const SizedBox(height: 32),

            // Medical Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.medical_services, color: theme.colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'হার্টের রোগীরা রোজা রাখার আগে অবশ্যই ডাক্তারের পরামর্শ নিন।',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFastingToggle(BuildContext context, ThemeData theme, WidgetRef ref, FastingState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: state.isFastingToday 
              ? [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)] 
              : [theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant.withOpacity(0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            state.isFastingToday ? Icons.brightness_3 : Icons.wb_sunny_outlined,
            color: state.isFastingToday ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            state.isFastingToday ? 'আপনি আজ রোজা রাখছেন' : 'আজ কি রোজা রাখছেন?',
            style: theme.textTheme.titleLarge?.copyWith(
              color: state.isFastingToday ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Switch(
            value: state.isFastingToday,
            onChanged: (_) => ref.read(fastingProvider.notifier).toggleFasting(),
            activeColor: theme.colorScheme.onPrimary,
            activeTrackColor: theme.colorScheme.onPrimary.withOpacity(0.3),
            inactiveThumbColor: theme.colorScheme.onSurfaceVariant,
            inactiveTrackColor: theme.colorScheme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value, 
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            title, 
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar(ThemeData theme, List<DateTime> history) {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Column(
        children: [
          Text(
            '${_getMonthName(now.month)} ${now.year}',
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: lastDayOfMonth.day,
            itemBuilder: (context, index) {
              final day = index + 1;
              final date = DateTime(now.year, now.month, day);
              final isFasted = history.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
              
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFasted ? theme.colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: date.day == now.day ? Border.all(color: theme.colorScheme.primary) : null,
                ),
                child: Text(
                  '$day',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isFasted ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    fontWeight: isFasted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBenefitsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রোজার বৈচনাজিক উপকারিতা', 
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildBenefitItem(theme, 'অটোফ্যাজি (Autophagy)', 'শরীরের ড্যামেজড কোষগুলো পরিষ্কার করতে সাহায্য করে।', Icons.auto_fix_high),
        _buildBenefitItem(theme, 'ইনসুলিন সেন্সিটিভিটি', 'রক্তে শর্করার মাত্রা নিয়ন্ত্রণে রাখে এবং হার্ট সুস্থ রাখে।', Icons.bloodtype),
        _buildBenefitItem(theme, 'রক্তচাপ নিয়ন্ত্রণ', 'সিস্টোলিক রক্তচাপ কমাতে সাহায্য করে।', Icons.monitor_heart),
      ],
    );
  }

  Widget _buildBenefitItem(ThemeData theme, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1), 
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  desc, 
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'];
    return months[month - 1];
  }
}
