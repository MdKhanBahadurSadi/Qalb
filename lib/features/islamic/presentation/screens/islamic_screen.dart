import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class IslamicScreen extends StatelessWidget {
  const IslamicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ইসলামিক ফিচারসমূহ',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAISection(
              context,
              'কুরআনিক প্রজ্ঞা (AI)',
              'হৃদয় ও প্রশান্তি নিয়ে কুরআনের শিক্ষা',
              Icons.auto_stories,
              '/home/islamic/wisdom',
              color: isDark ? const Color(0xFF3F51B5) : const Color(0xFF3949AB),
            ),
            const SizedBox(height: 12),
            _buildAISection(
              context,
              'আন-নাসিহা (AI)',
              'আপনার ইসলামিক ওয়েলনেস গাইড',
              Icons.auto_awesome,
              '/home/islamic/nasiha',
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildAISection(
              context,
              'মানসিক প্রশান্তি (AI)',
              'মন ভালো করার দুআ ও আধ্যাত্মিক পরামর্শ',
              Icons.spa,
              '/home/islamic/mood-wellness',
              color: isDark ? const Color(0xFF00695C) : const Color(0xFF00796B),
            ),
            const SizedBox(height: 12),
            _buildAISection(
              context,
              'সুন্নাহ ডায়েট প্ল্যানার (AI)',
              'স্বাস্থ্যসম্মত সুন্নাহ খাবার তালিকা',
              Icons.restaurant_menu,
              '/home/islamic/diet-planner',
              color: isDark ? const Color(0xFFBF360C) : const Color(0xFFE65100),
            ),
            const SizedBox(height: 24),
            Text(
              'অন্যান্য সেবাসমূহ',
              style: GoogleFonts.hindSiliguri(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildFeatureCard(
                  context,
                  'নামাজের সময়',
                  Icons.access_time_filled,
                  Colors.blue,
                  '/home/islamic/prayer-times',
                ),
                _buildFeatureCard(
                  context,
                  'জিকির কাউন্টার',
                  Icons.touch_app,
                  Colors.teal,
                  '/home/islamic/dhikr',
                ),
                _buildFeatureCard(
                  context,
                  'রোজা ট্র্যাকার',
                  Icons.calendar_today,
                  Colors.green,
                  '/home/islamic/fasting',
                ),
                _buildFeatureCard(
                  context,
                  'খাদ্য ও পুষ্টি',
                  Icons.eco,
                  Colors.redAccent,
                  '/home/islamic/nutrition',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAISection(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route, {
    required Color color,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.onPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.hindSiliguri(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.hindSiliguri(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onPrimary, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.hindSiliguri(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
