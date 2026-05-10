import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quranic_wisdom_provider.dart';

class QuranicWisdomScreen extends ConsumerWidget {
  const QuranicWisdomScreen({super.key});

  final List<Map<String, dynamic>> topics = const [
    {'id': 'Qalb', 'label': 'অন্তর (কলব)', 'icon': Icons.favorite_border, 'color': Color(0xFFE57373)},
    {'id': 'Peace', 'label': 'প্রশান্তি', 'icon': Icons.self_improvement, 'color': Color(0xFF4DB6AC)},
    {'id': 'Patience', 'label': 'ধৈর্য (সবর)', 'icon': Icons.hourglass_empty, 'color': Color(0xFF8D6E63)},
    {'id': 'Gratitude', 'label': 'শুকরিয়া', 'icon': Icons.celebration, 'color': Color(0xFFFFB74D)},
    {'id': 'Spiritual Wellness', 'label': 'আধ্যাত্মিক সুস্থতা', 'icon': Icons.spa, 'color': Color(0xFF81C784)},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wisdomState = ref.watch(quranicWisdomProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'কুরআনিক প্রজ্ঞা',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1A237E), const Color(0xFF283593)]
                  : [const Color(0xFF3949AB), const Color(0xFF283593)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: wisdomState.when(
        data: (wisdom) => wisdom == null 
            ? _buildTopicSelection(context, theme, ref, isDark) 
            : _buildWisdomDisplay(context, theme, ref, wisdom, isDark),
        loading: () => Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('ত্রুটি: $err', style: theme.textTheme.bodyMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicSelection(BuildContext context, ThemeData theme, WidgetRef ref, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                    : [Colors.white, const Color(0xFFF5F5F5)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: isDark ? const Color(0xFF7986CB) : const Color(0xFF3949AB),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'কুরআনের আলোয় আপনার হৃদয়ের যত্ন',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'নিচের একটি বিষয় বেছে নিন যার মাধ্যমে আপনি কুরআনের প্রজ্ঞা ও হার্ট ওয়েলনেস গাইডেন্স পেতে চান।',
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : const Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'বিষয়সমূহ',
            style: GoogleFonts.hindSiliguri(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          ...topics.map((topic) {
            final topicColor = topic['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => ref.read(quranicWisdomProvider.notifier).getWisdom(topic['id']),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: topicColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(topic['icon'], color: topicColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          topic['label'],
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWisdomDisplay(BuildContext context, ThemeData theme, WidgetRef ref, String wisdom, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 48,
                  color: isDark ? const Color(0xFF7986CB).withValues(alpha: 0.5) : const Color(0xFF3949AB).withValues(alpha: 0.2),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  wisdom,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.hindSiliguri(
                    fontSize: 18,
                    height: 1.8,
                    color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(quranicWisdomProvider),
            icon: const Icon(Icons.refresh_rounded),
            label: Text('অন্য বিষয় বেছে নিন', style: GoogleFonts.hindSiliguri(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: isDark ? const Color(0xFF283593) : const Color(0xFF3949AB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF3949AB).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
