import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qalb/features/smoking/domain/entities/craving_log.dart';
import 'package:qalb/features/smoking/presentation/providers/smoking_provider.dart';

class CravingLogScreen extends ConsumerStatefulWidget {
  const CravingLogScreen({super.key});

  @override
  ConsumerState<CravingLogScreen> createState() => _CravingLogScreenState();
}

class _CravingLogScreenState extends ConsumerState<CravingLogScreen> {
  double _intensity = 5;
  final List<String> _selectedTriggers = [];
  bool _drankWater = false;

  final List<String> _triggers = [
    'মানসিক চাপ', 'একাকীত্ব', 'খাবার পর', 'চা/কফি',
    'সামাজিক পরিবেশ', 'বিরক্তি', 'ক্লান্তি', 'অন্যান্য'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ক্র্যাভিং লগ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 30),
            _buildIntensitySlider(theme),
            const SizedBox(height: 30),
            _buildTriggerSelection(theme),
            const SizedBox(height: 30),
            _buildQuickReliefSection(theme),
            const SizedBox(height: 40),
            _buildSaveButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          'ক্র্যাভিং? আপনি পারবেন! 💪',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary, 
            fontWeight: FontWeight.w500,
            fontFamily: 'Noto Naskh Arabic',
          ),
        ),
        Text(
          '— আল্লাহ ধৈর্যশীলদের সাথে',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildIntensitySlider(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'তীব্রতা কতটুকু? (১-১০)', 
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: _intensity,
          min: 1,
          max: 10,
          divisions: 9,
          label: _intensity.round().toString(),
          activeColor: Color.lerp(
            isDark ? Colors.greenAccent : Colors.green, 
            isDark ? Colors.redAccent : Colors.red, 
            (_intensity - 1) / 9
          ),
          onChanged: (value) => setState(() => _intensity = value),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('সামান্য', style: theme.textTheme.labelSmall?.copyWith(color: isDark ? Colors.greenAccent : Colors.green)),
            Text('অসহ্য', style: theme.textTheme.labelSmall?.copyWith(color: isDark ? Colors.redAccent : Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildTriggerSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'কারণ কী হতে পারে?', 
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _triggers.map((trigger) {
            final isSelected = _selectedTriggers.contains(trigger);
            return FilterChip(
              label: Text(trigger),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTriggers.add(trigger);
                  } else {
                    _selectedTriggers.remove(trigger);
                  }
                });
              },
              selectedColor: theme.colorScheme.primary.withOpacity(0.2),
              checkmarkColor: theme.colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickReliefSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'তাৎক্ষণিক প্রশান্তি', 
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _ReliefCard(
          icon: Icons.air,
          title: 'শ্বাস-প্রশ্বাসের ব্যায়াম',
          subtitle: '৪-৭-৮ টেকনিক',
          onTap: () => context.push('/smoking/breathing'),
        ),
        _ReliefCard(
          icon: Icons.menu_book,
          title: 'জিকির করুন',
          subtitle: 'লা হাওলা ওয়া লা কুয়াতা ইল্লা বিল্লাহ',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('জিকির করুন: "লা হাওলা ওয়া লা কুয়াতা ইল্লা বিল্লাহ"')),
            );
          },
        ),
        CheckboxListTile(
          value: _drankWater,
          onChanged: (val) => setState(() => _drankWater = val ?? false),
          title: Text('এক গ্লাস পানি পান করুন', style: theme.textTheme.bodyMedium),
          secondary: Icon(Icons.water_drop, color: theme.colorScheme.secondary),
          contentPadding: EdgeInsets.zero,
          activeColor: theme.colorScheme.primary,
        ),
        _ReliefCard(
          icon: Icons.directions_walk,
          title: '৫ মিনিট হাঁটুন',
          subtitle: 'মন অন্যদিকে ফেরান',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('হাঁটা শুরু করুন! আল্লাহ আপনার সাথে আছেন।')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: () async {
        final log = CravingLog(
          intensity: _intensity,
          triggers: _selectedTriggers,
          timestamp: DateTime.now(),
          resolved: true,
          resolvedAt: DateTime.now(),
        );
        await ref.read(smokingProvider.notifier).saveCravingLog(log);
        
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              title: Text('মাশাআল্লাহ!', style: theme.textTheme.titleLarge),
              content: Text('আপনি ক্র্যাভিং কাটিয়ে উঠেছেন। আল্লাহ আপনাকে কবুল করুন।', style: theme.textTheme.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    context.pop(); // Close screen
                  },
                  child: Text('আলহামদুলিল্লাহ', style: TextStyle(color: theme.colorScheme.primary)),
                ),
              ],
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isDark ? theme.colorScheme.primary : Colors.green,
        foregroundColor: isDark ? theme.colorScheme.onPrimary : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('ক্র্যাভিং কাটিয়ে উঠলাম', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class _ReliefCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ReliefCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}
