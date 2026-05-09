import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalb/core/constants/app_constants.dart';

/// Provider for managing the application's locale.
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('bn')) {
    _loadLanguage();
  }

  void _loadLanguage() {
    try {
      final box = Hive.box(AppConstants.hiveSettingsBox);
      final lang = box.get('language', defaultValue: 'bn');
      state = Locale(lang);
    } catch (_) {
      state = const Locale('bn');
    }
  }

  void setLanguage(String langCode) {
    state = Locale(langCode);
    try {
      Hive.box(AppConstants.hiveSettingsBox).put('language', langCode);
    } catch (_) {}
  }
}

/// Provider for general notification settings.
final notificationsEnabledProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<bool> {
  NotificationsNotifier() : super(true) {
    _loadStatus();
  }

  void _loadStatus() {
    try {
      final box = Hive.box(AppConstants.hiveSettingsBox);
      state = box.get('notifications_enabled', defaultValue: true);
    } catch (_) {
      state = true;
    }
  }

  void toggle() {
    state = !state;
    try {
      Hive.box(AppConstants.hiveSettingsBox).put('notifications_enabled', state);
    } catch (_) {}
  }
}

/// Provider for prayer time notification settings.
final prayerNotificationsProvider = StateNotifierProvider<PrayerNotificationsNotifier, bool>((ref) {
  return PrayerNotificationsNotifier();
});

class PrayerNotificationsNotifier extends StateNotifier<bool> {
  PrayerNotificationsNotifier() : super(true) {
    _loadStatus();
  }

  void _loadStatus() {
    try {
      final box = Hive.box(AppConstants.hiveSettingsBox);
      state = box.get('prayer_notifications', defaultValue: true);
    } catch (_) {
      state = true;
    }
  }

  void toggle() {
    state = !state;
    try {
      Hive.box(AppConstants.hiveSettingsBox).put('prayer_notifications', state);
    } catch (_) {}
  }
}
