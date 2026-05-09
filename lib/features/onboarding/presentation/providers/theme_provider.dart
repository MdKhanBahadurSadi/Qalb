import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

/// Provider for managing the application's theme mode.
/// Persists the selected [ThemeMode] to Hive.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    try {
      final box = Hive.box(AppConstants.hiveSettingsBox);
      final index = box.get('themeMode', defaultValue: ThemeMode.system.index);
      state = ThemeMode.values[index];
    } catch (_) {
      // If box is not open or error occurs, fallback to system
      state = ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    try {
      Hive.box(AppConstants.hiveSettingsBox).put('themeMode', mode.index);
    } catch (_) {
      // Handle error if box is not open
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
