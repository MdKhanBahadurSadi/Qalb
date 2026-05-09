import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:qalb/shared/services/pdf_report_service.dart';
import 'package:qalb/features/auth/presentation/providers/auth_provider.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  String _selectedRange = 'শেষ ৩০ দিন';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('স্বাস্থ্য রিপোর্ট'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPdf(user?.name ?? 'ব্যবহারকারী'),
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
            _buildHistoryChart(theme),
            const SizedBox(height: 24),
            _buildSummaryCard(theme),
            const SizedBox(height: 24),
            Text(
              'রিস্ক ফ্যাক্টর ব্রেকডাউন', 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFactorsChart(theme),
            const SizedBox(height: 24),
            Text(
              'পরামর্শ', 
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRecommendations(theme),
            const SizedBox(height: 40),
            _buildIslamicReminder(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
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

  Widget _buildHistoryChart(ThemeData theme) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, top: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 20),
                FlSpot(1, 35),
                FlSpot(2, 25),
                FlSpot(3, 40),
                FlSpot(4, 30),
              ],
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 4,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(Icons.check, color: Colors.green),
        ),
        title: Text(
          'সর্বশেষ অ্যাসেসমেন্ট', 
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'আপনার রিস্ক স্কোর ১৫% কমেছে। জীবনযাত্রা নিয়ন্ত্রণে রাখুন।',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildFactorsChart(ThemeData theme) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const labels = ['ধূমপান', 'BMI', 'ব্যায়াম', 'খাদ্য'];
                  if (value.toInt() >= labels.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()], 
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeBarGroup(0, 8, Colors.red),
            _makeBarGroup(1, 5, Colors.orange),
            _makeBarGroup(2, 3, Colors.green),
            _makeBarGroup(3, 4, Colors.blue),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: color, width: 20, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }

  Widget _buildRecommendations(ThemeData theme) {
    final list = [
      'প্রতিদিন ৩০ মিনিট হাঁটুন।',
      'চিনি ও অতিরিক্ত লবণ পরিহার করুন।',
      'পর্যাপ্ত পরিমাণে পানি পান করুন।',
      'ধূমপান পুরোপুরি ছেড়ে দিন।',
    ];

    return Column(
      children: list.map((rec) => ListTile(
        leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
        title: Text(
          rec, 
          style: theme.textTheme.bodyMedium,
        ),
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
          Text(
            '— স্বাস্থ্য আল্লাহর নিয়ামত', 
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _exportPdf(String name) async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );
    
    try {
      await PdfReportService.generateAndShowReport(
        userName: name,
        riskScore: 25.5,
        riskCategory: 'Low Risk',
        riskFactors: [
          {'factor': 'Smoking', 'status': 'Former'},
          {'factor': 'BMI', 'status': '24.5 (Normal)'},
          {'factor': 'Exercise', 'status': 'Regular'},
        ],
        recommendations: [
          'Walk 30 mins daily.',
          'Avoid sugar and excess salt.',
          'Maintain current healthy habits.'
        ],
        history: [
          {'date': '2024-04-20', 'score': 30, 'category': 'Moderate'},
          {'date': '2024-05-08', 'score': 25.5, 'category': 'Low Risk'},
        ],
      );
    } finally {
      if (mounted) Navigator.pop(context); // Close loading
    }
  }
}
