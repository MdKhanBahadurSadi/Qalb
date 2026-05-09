import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/premium_feature_card.dart';

class IslamicScreenRedesign extends StatelessWidget {
  const IslamicScreenRedesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Assalamu Alaikum',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF004D40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader('AI Insights'),
                const SizedBox(height: 16),
                PremiumFeatureCard(
                  title: 'Quranic Wisdom (AI)',
                  subtitle: 'Reflections for your soul',
                  icon: Icons.auto_stories_rounded,
                  gradientColors: [const Color(0xFF3949AB), const Color(0xFF1A237E)],
                  onTap: () => context.push('/home/islamic/wisdom'),
                ),
                const SizedBox(height: 16),
                PremiumFeatureCard(
                  title: 'An-Nasiha (AI)',
                  subtitle: 'Personalized Islamic Guidance',
                  icon: Icons.auto_awesome_rounded,
                  gradientColors: [const Color(0xFF00796B), const Color(0xFF004D40)],
                  onTap: () => context.push('/home/islamic/nasiha'),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('Daily Essentials'),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCompactCard(context, 'Prayer Times', Icons.access_time_filled_rounded),
                    _buildCompactCard(context, 'Dhikr Counter', Icons.touch_app_rounded),
                    _buildCompactCard(context, 'Fasting Tracker', Icons.calendar_month_rounded),
                    _buildCompactCard(context, 'Sunnah Diet', Icons.eco_rounded),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF121212),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF00695C), size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
