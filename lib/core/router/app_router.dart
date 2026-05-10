import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import Screens
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/risk_prediction/presentation/screens/risk_prediction_screen.dart';
import '../../features/risk_prediction/presentation/screens/risk_result_screen.dart';
import '../../features/risk_prediction/presentation/screens/report_screen.dart';
import '../../features/risk_prediction/presentation/screens/health_profile_form_screen.dart';
import '../../features/islamic/presentation/screens/islamic_screen.dart';
import '../../features/islamic/presentation/screens/nasiha_screen.dart';
import '../../features/islamic/presentation/screens/prayer_times_screen.dart';
import '../../features/islamic/presentation/screens/dhikr_list_screen.dart';
import '../../features/islamic/presentation/screens/dhikr_counter_screen.dart';
import '../../features/islamic/presentation/screens/fasting_tracker_screen.dart';
import '../../features/islamic/presentation/screens/sunnah_nutrition_screen.dart';
import '../../features/islamic/presentation/screens/sunnah_diet_planner_screen.dart';
import '../../features/islamic/presentation/screens/mood_wellness_screen.dart';
import '../../features/islamic/presentation/screens/quranic_wisdom_screen.dart';
import '../../features/smoking/presentation/screens/smoking_screen.dart';
import '../../features/smoking/presentation/screens/smoking_setup_screen.dart';
import '../../features/smoking/presentation/screens/craving_screen.dart';
import '../../features/smoking/presentation/screens/craving_log_screen.dart';
import '../../features/smoking/presentation/screens/breathing_exercise_screen.dart';
import '../../features/islamic/domain/entities/dhikr.dart';

// Import Widgets & Providers
import '../../shared/widgets/scaffold_with_nav_bar.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingCompleted = ref.watch(onboardingProvider);
  final splashFinished = ref.watch(splashFinishedProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      // If auth state is still loading, stay on the current screen (likely splash)
      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggingIn = state.matchedLocation.startsWith('/auth');
      final isSplashing = state.matchedLocation == '/splash';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // 1. Wait for splash animation to finish
      if (!splashFinished) {
        return isSplashing ? null : '/splash';
      }

      // 2. If splash is finished and we are still on /splash, decide where to go
      if (isSplashing) {
        if (user == null) return '/auth/login';
        if (!onboardingCompleted) return '/onboarding';
        return '/home/dashboard';
      }

      // 3. Auth protection
      if (user == null) {
        return isLoggingIn ? null : '/auth/login';
      }

      // 4. Onboarding protection
      if (!onboardingCompleted) {
        return isOnboarding ? null : '/onboarding';
      }

      // 5. Prevent logged in users from seeing auth screens
      if (isLoggingIn || isOnboarding) {
        return '/home/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/dashboard',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/predict',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: RiskPredictionScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/spiritual',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: IslamicScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'nasiha',
                    builder: (context, state) => const NasihaScreen(),
                  ),
                  GoRoute(
                    path: 'prayer-times',
                    builder: (context, state) => const PrayerTimesScreen(),
                  ),
                  GoRoute(
                    path: 'dhikr',
                    builder: (context, state) => const DhikrListScreen(),
                    routes: [
                      GoRoute(
                        path: 'counter',
                        builder: (context, state) {
                          final dhikr = state.extra as Dhikr;
                          return DhikrCounterScreen(dhikr: dhikr);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'fasting',
                    builder: (context, state) => const FastingTrackerScreen(),
                  ),
                  GoRoute(
                    path: 'nutrition',
                    builder: (context, state) => const SunnahNutritionScreen(),
                  ),
                  GoRoute(
                    path: 'diet-planner',
                    builder: (context, state) => const SunnahDietPlannerScreen(),
                  ),
                  GoRoute(
                    path: 'mood-wellness',
                    builder: (context, state) => const MoodWellnessScreen(),
                  ),
                  GoRoute(
                    path: 'wisdom',
                    builder: (context, state) => const QuranicWisdomScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/smoking',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SmokingScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Sub-routes that should probably be on top of the Nav Bar
      GoRoute(
        path: '/risk-result',
        builder: (context, state) => const RiskResultScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const ReportScreen(),
      ),
      GoRoute(
        path: '/health-form',
        builder: (context, state) => const HealthProfileFormScreen(),
      ),
      GoRoute(
        path: '/smoking/setup',
        builder: (context, state) => const SmokingSetupScreen(),
      ),
      GoRoute(
        path: '/smoking/craving',
        builder: (context, state) => const CravingScreen(),
      ),
      GoRoute(
        path: '/smoking/craving-log',
        builder: (context, state) => const CravingLogScreen(),
      ),
      GoRoute(
        path: '/smoking/breathing',
        builder: (context, state) => const BreathingExerciseScreen(),
      ),
    ],
  );
});
