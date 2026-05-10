import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.favorite,
      title: "আপনার হৃদয়ের যত্ন নিন",
      subtitle: "AI প্রযুক্তি ব্যবহার করে হার্ট অ্যাটাকের ঝুঁকি আগেই জানুন",
      colors: [const Color(0xFF0F6E56), const Color(0xFF1D9E75)],
    ),
    OnboardingData(
      icon: Icons.psychology,
      title: "AI-চালিত রিস্ক বিশ্লেষণ",
      subtitle: "আপনার স্বাস্থ্য তথ্য বিশ্লেষণ করে ব্যক্তিগত সুপারিশ পাবেন",
      colors: [const Color(0xFF1976D2), const Color(0xFF42A5F5)],
    ),
    OnboardingData(
      icon: Icons.mosque,
      title: "ইসলামিক স্বাস্থ্য গাইড",
      subtitle: "নামাজ, জিকির, সুন্নাহ খাবার ও রোজার মাধ্যমে হৃদয় সুস্থ রাখুন",
      colors: [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
    ),
    OnboardingData(
      icon: Icons.smoke_free,
      title: "ধূমপান মুক্ত জীবন",
      subtitle: "AI-সহায়তায় ধূমপান ছেড়ে হৃদয়কে সুস্থ করুন",
      colors: [const Color(0xFFE65100), const Color(0xFFF4511E)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _pages[_currentPage].colors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final data = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onPrimary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(data.icon, size: 100, color: theme.colorScheme.onPrimary),
                          ),
                          const SizedBox(height: 60),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data.subtitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary.withValues(alpha: _currentPage == index ? 1.0 : 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_currentPage < _pages.length - 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _completeOnboarding,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.onPrimary,
                              foregroundColor: _pages[_currentPage].colors[0],
                              minimumSize: const Size(0, 48),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('পরবর্তী'),
                          ),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: _completeOnboarding,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.onPrimary,
                          foregroundColor: _pages[_currentPage].colors[0],
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'শুরু করুন',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _pages[_currentPage].colors[0],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
  });
}
