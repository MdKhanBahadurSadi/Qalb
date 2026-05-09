import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadStatus();
  }

  void _loadStatus() {
    final box = Hive.box(AppConstants.hiveSettingsBox);
    state = box.get('onboardingCompleted', defaultValue: false);
  }

  Future<void> completeOnboarding() async {
    final box = Hive.box(AppConstants.hiveSettingsBox);
    await box.put('onboardingCompleted', true);
    state = true;
  }
}

// Additional provider for splash delay tracking
final splashFinishedProvider = StateProvider.autoDispose<bool>((ref) => false);
