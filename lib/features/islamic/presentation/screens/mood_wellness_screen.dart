import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/mood_wellness_provider.dart';

class MoodWellnessScreen extends ConsumerWidget {
  const MoodWellnessScreen({super.key});

  List<Map<String, dynamic>> _getMoods(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return [
      {'id': 'anxious', 'label': 'উদ্বিগ্ন/দুশ্চিন্তাগ্রস্ত', 'icon': Icons.waves, 'color': isDark ? Colors.blueGrey.shade300 : Colors.blueGrey},
      {'id': 'stressed', 'label': 'চাপগ্রস্ত', 'icon': Icons.warning_amber_rounded, 'color': isDark ? Colors.orangeAccent : Colors.orange},
      {'id': 'angry', 'label': 'রাগান্বিত', 'icon': Icons.local_fire_department, 'color': isDark ? Colors.redAccent : Colors.red},
      {'id': 'sad', 'label': 'দুঃখিত', 'icon': Icons.sentiment_very_dissatisfied, 'color': isDark ? Colors.blueAccent : Colors.blue},
      {'id': 'lonely', 'label': 'একাকী', 'icon': Icons.person_outline, 'color': isDark ? Colors.indigoAccent : Colors.indigo},
      {'id': 'hopeless', 'label': 'নিরাশ', 'icon': Icons.cloud_queue, 'color': isDark ? Colors.grey.shade400 : Colors.grey},
      {'id': 'grateful', 'label': 'কৃতজ্ঞ', 'icon': Icons.favorite, 'color': isDark ? Colors.pinkAccent : Colors.pink},
      {'id': 'fearful', 'label': 'ভীত', 'icon': Icons.security, 'color': isDark ? Colors.deepPurpleAccent : Colors.deepPurple},
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wellnessState = ref.watch(moodWellnessProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('মানসিক প্রশান্তি', style: GoogleFonts.hindSiliguri()),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: wellnessState.when(
        data: (guidance) => guidance == null ? _buildMoodGrid(context, theme, ref) : _buildGuidance(context, theme, ref, guidance),
        loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
        error: (err, stack) => Center(child: Text('ত্রুটি: $err', style: theme.textTheme.bodyMedium)),
      ),
    );
  }

  Widget _buildMoodGrid(BuildContext context, ThemeData theme, WidgetRef ref) {
    final moods = _getMoods(theme);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'আপনি এখন কেমন অনুভব করছেন?',
            style: GoogleFonts.hindSiliguri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'আপনার বর্তমান অনুভূতির ওপর ভিত্তি করে আমরা প্রশান্তিদায়ক আয়াত ও দুআ খুঁজে দেব।',
            style: GoogleFonts.hindSiliguri(
              fontSize: 16, 
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                final moodColor = mood['color'] as Color;
                
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: moodColor.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: moodColor.withValues(alpha: 0.3)),
                  ),
                  child: InkWell(
                    onTap: () => ref.read(moodWellnessProvider.notifier).getGuidance(mood['id']),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(mood['icon'], color: moodColor, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          mood['label'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: moodColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidance(BuildContext context, ThemeData theme, WidgetRef ref, String guidance) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SelectableText(
                guidance,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  height: 1.6,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(moodWellnessProvider),
            icon: const Icon(Icons.refresh),
            label: Text('আবার বেছে নিন', style: GoogleFonts.hindSiliguri()),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }
}
