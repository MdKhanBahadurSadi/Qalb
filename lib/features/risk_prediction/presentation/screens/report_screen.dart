import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:qalb/shared/services/pdf_report_service.dart';
import 'package:qalb/features/auth/presentation/providers/auth_provider.dart';
import '../providers/health_history_provider.dart';
import '../../domain/entities/risk_result.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  String _selectedRange = 'সব';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final historyAsync = ref.watch(healthHistoryProvider);
    final theme = Theme.of(context);

    return historyAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (history) {
        if (history.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('স্বাস্থ্য রিপোর্ট')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  const Text('এখনো কোনো হিস্ট্রি নেই।'),
                  const SizedBox(height: 8),
                  const Text('আগে আপনার রিস্ক ক্যালকুলেট করুন।'),
                ],
              ),
            ),
          );
        }

        final latestResult = history.first;

        return Scaffold(
          appBar: AppBar(
            title: const Text('স্বাস্থ্য রিপোর্ট'),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () => _exportPdf(user?.name ?? 'ব্যবহারকারী', latestResult, history),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRangeSelector(theme),
                const SizedBox(height: 24),
                Text(
                  'রিস্ক স্কোর হিস্ট্রি', 
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildHistoryChart(theme, history),
                const SizedBox(height: 24),
                _buildSummaryCard(theme, latestResult, history),
                const SizedBox(height: 24),
                Text(
                  'রিস্ক ফ্যাক্টর ব্রেকডাউন', 
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildFactorsChart(theme, latestResult),
                const SizedBox(height: 24),
                Text(
                  'পরামর্শ', 
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildRecommendations(theme, latestResult),
                const SizedBox(height: 40),
                _buildIslamicReminder(theme),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRangeSelector(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['শেষ ৩০ দিন', '৬ মাস', 'সব'].map((range) {
          final isSelected = _selectedRange == range;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(range),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedRange = range),
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryChart(ThemeData theme, List<RiskResult> history) {
    final reversedHistory = history.reversed.toList();
    final spots = reversedHistory.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.score.toDouble());
    }).toList();

    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, top: 16, left: 8, bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= reversedHistory.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('dd/MM').format(reversedHistory[value.toInt()].calculatedAt),
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, RiskResult latest, List<RiskResult> history) {
    String trendText = "আপনার প্রথম অ্যাসেসমেন্ট সম্পন্ন হয়েছে।";
    IconData trendIcon = Icons.info_outline;
    Color trendColor = Colors.blue;

    if (history.length > 1) {
      final previous = history[1];
      final diff = latest.score - previous.score;
      if (diff < 0) {
        trendText = "আপনার রিস্ক স্কোর ${diff.abs()}% কমেছে। সাবাশ!";
        trendIcon = Icons.trending_down;
        trendColor = Colors.green;
      } else if (diff > 0) {
        trendText = "আপনার রিস্ক স্কোর $diff% বেড়েছে। সতর্ক হোন।";
        trendIcon = Icons.trending_up;
        trendColor = Colors.red;
      } else {
        trendText = "আপনার রিস্ক স্কোর স্থিতিশীল আছে।";
        trendIcon = Icons.trending_flat;
        trendColor = Colors.orange;
      }
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: trendColor.withValues(alpha: 0.1),
          child: Icon(trendIcon, color: trendColor),
        ),
        title: Text(
          'সর্বশেষ অ্যাসেসমেন্ট (${latest.score}%)', 
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          trendText,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildFactorsChart(ThemeData theme, RiskResult latest) {
    final factors = latest.topRiskFactors;
    if (factors.isEmpty) {
      return const Center(child: Text('কোনো বড় রিস্ক ফ্যাক্টর পাওয়া যায়নি।'));
    }

    return Column(
      children: factors.map((f) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          title: Text(f),
          trailing: const Text('উচ্চ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      )).toList(),
    );
  }

  Widget _buildRecommendations(ThemeData theme, RiskResult latest) {
    return Column(
      children: latest.recommendations.map((rec) => ListTile(
        leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
        title: Text(rec),
        dense: true,
      )).toList(),
    );
  }

  Widget _buildIslamicReminder(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Text(
            'الصِّحَّةُ نِعْمَةٌ مِنَ اللَّهِ',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Naskh Arabic',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '— স্বাস্থ্য আল্লাহর নিয়ামত', 
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _exportPdf(String name, RiskResult latest, List<RiskResult> history) async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );
    
    try {
      await PdfReportService.generateAndShowReport(
        userName: name,
        riskScore: latest.score.toDouble(),
        riskCategory: latest.category.name.toUpperCase(),
        riskFactors: latest.topRiskFactors.map((f) => {'factor': f, 'status': 'High'}).toList(),
        recommendations: latest.recommendations,
        history: history.map((h) => {
          'date': DateFormat('yyyy-MM-dd').format(h.calculatedAt),
          'score': h.score,
          'category': h.category.name,
        }).toList(),
      );
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }
}
