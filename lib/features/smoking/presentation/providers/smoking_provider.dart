import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalb/core/constants/app_constants.dart';
import 'package:qalb/features/smoking/domain/entities/smoking_profile.dart';
import 'package:qalb/features/smoking/domain/entities/health_milestone.dart';
import 'package:qalb/features/smoking/domain/entities/craving_log.dart';
import 'package:qalb/shared/services/notification_service.dart';

final smokingProvider = StateNotifierProvider<SmokingNotifier, SmokingProfile>((ref) {
  return SmokingNotifier();
});

class SmokingNotifier extends StateNotifier<SmokingProfile> {
  SmokingNotifier() : super(const SmokingProfile()) {
    _loadProfile();
  }

  final _box = Hive.box(AppConstants.hiveSmokingBox);

  void _loadProfile() {
    final data = _box.get('profile');
    if (data != null) {
      state = SmokingProfile.fromJson(Map<String, dynamic>.from(data));
      _checkMilestones();
    }
  }

  void _checkMilestones() {
    if (!state.isInRecovery || state.quitDate == null) return;
    
    final milestones = SmokingCalculations.getMilestones(state.quitDate);
    final achieved = milestones.where((m) => m.isAchieved).toList();
    
    if (achieved.isNotEmpty) {
      // Find milestones achieved in the last 10 minutes to avoid spamming old ones
      final now = DateTime.now();
      for (var m in achieved) {
        if (m.achievedAt != null && now.difference(m.achievedAt!).inMinutes < 10) {
          NotificationService.showSmokingMilestone(m.title);
        }
      }
    }
  }

  Future<void> updateProfile(SmokingProfile profile) async {
    state = profile;
    await _box.put('profile', profile.toJson());
  }

  Future<void> startRecovery({DateTime? quitDate}) async {
    state = state.copyWith(
      isInRecovery: true,
      quitDate: quitDate ?? DateTime.now(),
    );
    await _box.put('profile', state.toJson());
  }

  Future<void> saveCravingLog(CravingLog log) async {
    final logs = _box.get('craving_logs', defaultValue: []);
    final updatedLogs = List<dynamic>.from(logs)..add(log.toJson());
    await _box.put('craving_logs', updatedLogs);
  }

  List<CravingLog> getCravingLogs() {
    final logs = _box.get('craving_logs', defaultValue: []);
    return List<dynamic>.from(logs)
        .map((l) => CravingLog.fromJson(Map<String, dynamic>.from(l)))
        .toList();
  }

  Future<void> reset() async {
    state = const SmokingProfile();
    await _box.delete('profile');
    await _box.delete('craving_logs');
  }
}

// Stream to provide current time for tickers
final smokingTickerProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

// Helper for calculations
class SmokingCalculations {
  static Duration getDuration(DateTime? quitDate) {
    if (quitDate == null) return Duration.zero;
    return DateTime.now().difference(quitDate);
  }

  static int getCigarettesAvoided(DateTime? quitDate, int cigarettesPerDay) {
    if (quitDate == null) return 0;
    final duration = DateTime.now().difference(quitDate);
    final totalMinutes = duration.inMinutes;
    return ((totalMinutes / (24 * 60)) * cigarettesPerDay).floor();
  }

  static double getMoneySaved(int avoided, double packagePrice) {
    return avoided * (packagePrice / 20);
  }

  static double getHeartRiskReduction(DateTime? quitDate) {
    if (quitDate == null) return 0;
    final duration = DateTime.now().difference(quitDate);
    // Simple linear interpolation for 1 year = 50% reduction
    final days = duration.inDays;
    if (days >= 365) return 50.0;
    return (days / 365.0) * 50.0;
  }

  static List<HealthMilestone> getMilestones(DateTime? quitDate) {
    final defaultMilestones = HealthMilestone.defaultMilestones;
    if (quitDate == null) return defaultMilestones;

    final now = DateTime.now();
    return defaultMilestones.map((m) {
      final milestoneTime = quitDate.add(m.timeAfterQuitting);
      final isAchieved = now.isAfter(milestoneTime);
      return m.copyWith(
        isAchieved: isAchieved,
        achievedAt: isAchieved ? milestoneTime : null,
      );
    }).toList();
  }
}
