import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quranic_wisdom_provider.dart';

class QuranicWisdomScreen extends ConsumerWidget {
  const QuranicWisdomScreen({super.key});

  final List<Map<String, dynamic>> topics = const [
    {'id': 'Qalb', 'label': 'অন্তর (কলব)', 'icon': Icons.favorite_border, 'color': Colors.red},
    {'id': 'Peace', 'label': 'প্রশান্তি', 'icon': Icons.self_improvement, 'color': Colors.teal},
    {'id': 'Patience', 'label': 'ধৈর্য (সবর)', 'icon': Icons.hourglass_empty, 'color': Colors.brown},
    {'id': 'Gratitude', 'label': 'শুকরিয়া', 'icon': Icons.celebration, 'color': Colors.amber},
    {'id': 'Spiritual Wellness', 'label': 'আধ্যাত্মিক সুস্থতা', 'icon': Icons.spa, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wisdomState = ref.watch(quranicWisdomProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('কুরআনিক প্রজ্ঞা', style: GoogleFonts.hindSiliguri()),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: wisdomState.when(
        data: (wisdom) => wisdom == null 
            ? _buildTopicSelection(context, theme, ref) 
            : _buildWisdomDisplay(context, theme, ref, wisdom),
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (err, stack) => Center(
          child: Text('ত্রুটি: $err', style: theme.textTheme.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildTopicSelection(BuildContext context, ThemeData theme, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'কুরআনের আলোয় আপনার হৃদয়ের যত্ন',
            style: GoogleFonts.hindSiliguri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'নিচের একটি বিষয় বেছে নিন যার মাধ্যমে আপনি কুরআনের প্রজ্ঞা ও হার্ট ওয়েলনেস গাইডেন্স পেতে চান।',
            style: GoogleFonts.hindSiliguri(
              fontSize: 16, 
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                final topicColor = topic['color'] as Color;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => ref.read(quranicWisdomProvider.notifier).getWisdom(topic['id']),
                    leading: CircleAvatar(
                      backgroundColor: topicColor.withOpacity(0.1),
                      child: Icon(topic['icon'], color: topicColor),
                    ),
                    title: Text(
                      topic['label'],
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios, 
                      size: 16, 
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    tileColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
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

  Widget _buildWisdomDisplay(BuildContext context, ThemeData theme, WidgetRef ref, String wisdom) {
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
                wisdom,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 16,
                  height: 1.7,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(quranicWisdomProvider),
            icon: const Icon(Icons.refresh),
            label: Text('অন্য বিষয় বেছে নিন', style: GoogleFonts.hindSiliguri()),
            style: theme.elevatedButtonTheme.style,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
