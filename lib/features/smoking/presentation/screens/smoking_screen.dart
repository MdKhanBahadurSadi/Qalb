import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'smoking_setup_screen.dart';
import 'smoking_dashboard_screen.dart';
import '../providers/smoking_provider.dart';

class SmokingScreen extends ConsumerWidget {
  const SmokingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(smokingProvider);

    if (profile.isInRecovery) {
      return const SmokingDashboardScreen();
    } else {
      return const SmokingSetupScreen();
    }
  }
}
