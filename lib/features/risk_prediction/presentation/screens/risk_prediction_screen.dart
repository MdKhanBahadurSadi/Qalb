import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qalb/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:qalb/core/constants/app_constants.dart';
import 'package:qalb/features/risk_prediction/domain/entities/risk_result.dart';

class RiskPredictionScreen extends ConsumerWidget {
  const RiskPredictionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('prediction.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/report'),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => _buildContent(context, theme, data.latestResult),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, RiskResult? latestResult) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context, theme, latestResult),
          const SizedBox(height: 32),
          Text(
            'কেন আপনার হার্ট রিস্ক পরীক্ষা করা জরুরি?',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            theme,
            Icons.speed,
            'দ্রুত শনাক্তকরণ',
            'প্রাথমিক লক্ষণগুলো শনাক্ত করে বড় ঝুঁকি এড়ানো সম্ভব।',
          ),
          _buildInfoCard(
            theme,
            Icons.psychology,
            'AI চালিত বিশ্লেষণ',
            'আমাদের উন্নত মেশিন লার্নিং মডেল আপনার স্বাস্থ্যের সঠিক তথ্য প্রদান করে।',
          ),
          _buildInfoCard(
            theme,
            Icons.auto_awesome,
            'সুন্নাহ ভিত্তিক গাইডলাইন',
            'রিস্ক কমানোর জন্য আমরা আপনাকে আধুনিক চিকিৎসার পাশাপাশি সুন্নাহ ভিত্তিক পরামর্শ দেই।',
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.push('/health-form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                latestResult == null ? 'পরীক্ষা শুরু করুন' : 'নতুন করে পরীক্ষা করুন',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, ThemeData theme, RiskResult? result) {
    if (result == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.monitor_heart, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            const Text(
              'আপনি এখনো কোনো হার্ট রিস্ক পরীক্ষা করেননি।',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    final categoryColor = _getCategoryColor(result.category, theme.brightness == Brightness.dark);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: categoryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            'আপনার সর্বশেষ রিস্ক স্কোর',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${result.score}%',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getCategoryText(result.category),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'পরীক্ষা করা হয়েছে: ${_formatDate(result.calculatedAt)}',
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
