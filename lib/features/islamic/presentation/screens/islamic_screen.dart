import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../widgets/premium_feature_card.dart';

class IslamicScreen extends StatefulWidget {
  const IslamicScreen({super.key});

  @override
  State<IslamicScreen> createState() => _IslamicScreenState();
}

class _IslamicScreenState extends State<IslamicScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAnimatedHeader(isDark, theme),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionTitle('স্পিরিচুয়াল এআই (AI)', textColor),
                  const SizedBox(height: 16),
                  PremiumFeatureCard(
                    title: 'কুরআনিক প্রজ্ঞা (AI)',
                    subtitle: 'হৃদয় ও প্রশান্তি নিয়ে কুরআনের শিক্ষা',
                    icon: Icons.auto_stories_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFF283593), const Color(0xFF1A237E)]
                        : [const Color(0xFF3949AB), const Color(0xFF283593)],
                    onTap: () => context.push('/home/spiritual/wisdom'),
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureCard(
                    title: 'আন-নাসিহা (AI)',
                    subtitle: 'আপনার স্পিরিচুয়াল ওয়েলনেস গাইড',
                    icon: Icons.auto_awesome_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFF00695C), const Color(0xFF004D40)]
                        : [const Color(0xFF00897B), const Color(0xFF00695C)],
                    onTap: () => context.push('/home/spiritual/nasiha'),
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureCard(
                    title: 'মানসিক প্রশান্তি (AI)',
                    subtitle: 'মন ভালো করার দুআ ও পরামর্শ',
                    icon: Icons.spa_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFF004D40), const Color(0xFF00251A)]
                        : [const Color(0xFF26A69A), const Color(0xFF00796B)],
                    onTap: () => context.push('/home/spiritual/mood-wellness'),
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureCard(
                    title: 'সুন্নাহ ডায়েট (AI)',
                    subtitle: 'স্বাস্থ্যসম্মত সুন্নাহ খাবার তালিকা',
                    icon: Icons.restaurant_menu_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFFBF360C), const Color(0xFF870000)]
                        : [const Color(0xFFE65100), const Color(0xFFBF360C)],
                    onTap: () => context.push('/home/spiritual/diet-planner'),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('প্রয়োজনীয় টুলস', textColor),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.88,
                    children: [
                      _buildGlassCard(
                        context: context,
                        title: 'নামাজের সময়',
                        icon: Icons.access_time_filled_rounded,
                        color: Colors.blueAccent,
                        route: '/home/spiritual/prayer-times',
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      _buildGlassCard(
                        context: context,
                        title: 'জিকির কাউন্টার',
                        icon: Icons.touch_app_rounded,
                        color: Colors.teal,
                        route: '/home/spiritual/dhikr',
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      _buildGlassCard(
                        context: context,
                        title: 'রোজা ট্র্যাকার',
                        icon: Icons.calendar_month_rounded,
                        color: Colors.green,
                        route: '/home/spiritual/fasting',
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        isDark: isDark,
                      ),
                      _buildGlassCard(
                        context: context,
                        title: 'খাদ্য ও পুষ্টি',
                        icon: Icons.eco_rounded,
                        color: Colors.orangeAccent,
                        route: '/home/spiritual/nutrition',
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(bool isDark, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 240.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24.0, bottom: 16.0, right: 24.0),
        title: Text(
          'স্পিরিচুয়াল সেবাসমূহ',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
            shadows: [
              const Shadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Base Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF00332B), const Color(0xFF001A15)]
                      : [const Color(0xFF00796B), const Color(0xFF004D40)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
            // Decorative Circles / Patterns
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Glassmorphism Overlay
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Greeting Text
            Positioned(
              top: 80,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'আসসালামু আলাইকুম',
                    style: GoogleFonts.hindSiliguri(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'আপনার দিনটি বরকতময় হোক',
                    style: GoogleFonts.hindSiliguri(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF00796B),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.hindSiliguri(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String route,
    required Color surfaceColor,
    required Color textColor,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(24),
        splashColor: color.withValues(alpha: 0.1),
        highlightColor: color.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: isDark ? color.withValues(alpha: 0.9) : color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.hindSiliguri(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
