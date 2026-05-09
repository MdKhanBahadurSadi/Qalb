import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/dhikr_datasource.dart';
import '../../domain/entities/dhikr.dart';

class DhikrState {
  final List<Dhikr> dhikrs;
  final int streak;
  DhikrState({required this.dhikrs, required this.streak});
}

class DhikrNotifier extends StateNotifier<DhikrState> {
  DhikrNotifier() : super(DhikrState(dhikrs: [], streak: 0)) {
    _init();
  }

  Future<void> _init() async {
    // Use the constant box name to avoid conflicts
    final box = Hive.box(AppConstants.hiveDhikrBox);
    final allDhikrs = DhikrDataSource.getDhikrs();
    
    // Load current counts from Hive
    final List<Dhikr> updatedDhikrs = allDhikrs.map((d) {
      final count = box.get('count_${d.id}', defaultValue: 0);
      return d.copyWith(currentCount: count);
    }).toList();

    final streak = box.get('dhikr_streak', defaultValue: 0);
    state = DhikrState(dhikrs: updatedDhikrs, streak: streak);
    
    _checkStreak();
  }

  Future<void> incrementCount(String id) async {
    final box = Hive.box(AppConstants.hiveDhikrBox);
    final index = state.dhikrs.indexWhere((d) => d.id == id);
    if (index == -1) return;

    final dhikr = state.dhikrs[index];
    final newCount = dhikr.currentCount + 1;
    
    await box.put('count_$id', newCount);
    
    final newList = [...state.dhikrs];
    newList[index] = dhikr.copyWith(currentCount: newCount);
    
    state = DhikrState(dhikrs: newList, streak: state.streak);
    
    _updateStreak();
  }

  Future<void> resetCount(String id) async {
    final box = Hive.box(AppConstants.hiveDhikrBox);
    final index = state.dhikrs.indexWhere((d) => d.id == id);
    if (index == -1) return;

    await box.put('count_$id', 0);
    
    final newList = [...state.dhikrs];
    newList[index] = state.dhikrs[index].copyWith(currentCount: 0);
    
    state = DhikrState(dhikrs: newList, streak: state.streak);
  }

  void _checkStreak() {
    final box = Hive.box(AppConstants.hiveDhikrBox);
    final lastDateStr = box.get('last_dhikr_date');
    if (lastDateStr == null) return;

    final lastDate = DateTime.parse(lastDateStr);
    final now = DateTime.now();
    final difference = now.difference(lastDate).inDays;

    if (difference > 1) {
      box.put('dhikr_streak', 0);
      state = DhikrState(dhikrs: state.dhikrs, streak: 0);
    }
  }

  void _updateStreak() {
    final box = Hive.box(AppConstants.hiveDhikrBox);
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();
    final lastDateStr = box.get('last_dhikr_date');

    if (lastDateStr != todayStr) {
      final currentStreak = box.get('dhikr_streak', defaultValue: 0);
      final newStreak = currentStreak + 1;
      box.put('dhikr_streak', newStreak);
      box.put('last_dhikr_date', todayStr);
      state = DhikrState(dhikrs: state.dhikrs, streak: newStreak);
    }
  }
}

final dhikrProvider = StateNotifierProvider<DhikrNotifier, DhikrState>((ref) {
  return DhikrNotifier();
});

final dhikrStreakProvider = Provider<int>((ref) {
  return ref.watch(dhikrProvider.select((s) => s.streak));
});
