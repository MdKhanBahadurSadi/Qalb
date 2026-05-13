import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/risk_prediction_provider.dart';

class RiskResultScreen extends ConsumerWidget {
  const RiskResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskState = ref.watch(riskPredictionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ফলাফল'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: riskState.when(
        data: (riskValue) => _buildResult(context, theme, riskValue),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildResult(BuildContext context, ThemeData theme, double riskValue) {
    // Assuming riskValue is between 0 and 1, convert to percentage
    final percentage = (riskValue * 100).clamp(0, 100);
    
    Color riskColor;
    String riskText;
    String recommendation;

    if (percentage < 20) {
      riskColor = Colors.green;
      riskText = 'কম ঝুঁকি';
      recommendation = 'আপনার হার্ট সুস্থ আছে। স্বাস্থ্যকর জীবনযাপন অব্যাহত রাখুন।';
    } else if (percentage < 50) {
      riskColor = Colors.orange;
      riskText = 'মাঝারি ঝুঁকি';
      recommendation = 'সতর্ক হওয়া প্রয়োজন। নিয়মিত ব্যায়াম এবং খাদ্যাভ্যাসে পরিবর্তন আনুন। চিকিৎসকের পরামর্শ নিন।';
    } else {
      riskColor = Colors.red;
      riskText = 'উচ্চ ঝুঁকি';
      recommendation = 'দ্রুত চিকিৎসকের পরামর্শ নিন। আপনার হার্টের বিশেষ যত্ন প্রয়োজন। নিয়মিত স্বাস্থ্য পরীক্ষা করান।';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: riskColor.withValues(alpha: 0.2), width: 10),
            ),
            child: Column(
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  riskText,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _ResultCard(
            title: 'পরামর্শ',
            content: recommendation,
            icon: Icons.lightbulb,
            color: riskColor,
          ),
          const SizedBox(height: 20),
          _ResultCard(
            title: 'পরবর্তী পদক্ষেপ',
            content: '১. নিয়মিত রক্তচাপ পরীক্ষা করুন\n২. ধূমপান বর্জন করুন\n৩. প্রতিদিন অন্তত ৩০ মিনিট হাঁটুন',
            icon: Icons.checklist,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => context.go('/home/dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ড্যাশবোর্ডে ফিরে যান', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _ResultCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
