import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FastingState {
  final bool isFastingToday;
  final int streak;
  final List<DateTime> fastingHistory;

  FastingState({
    required this.isFastingToday,
    required this.streak,
    required this.fastingHistory,
  });
}

class FastingNotifier extends StateNotifier<FastingState> {
  static const String boxName = 'fasting_box';
  static const String historyKey = 'fasting_history';
  static const String streakKey = 'fasting_streak';

  FastingNotifier() : super(FastingState(isFastingToday: false, streak: 0, fastingHistory: [])) {
    _init();
  }

  Future<void> _init() async {
    final box = await Hive.openBox(boxName);
    
    final List<String> historyStrings = box.get(historyKey, defaultValue: <String>[]);
    final List<DateTime> history = historyStrings.map((s) => DateTime.parse(s)).toList();
    
    final streak = box.get(streakKey, defaultValue: 0);
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isFastingToday = history.any((d) => d.isAtSameMomentAs(today));

    state = FastingState(
      isFastingToday: isFastingToday,
      streak: streak,
      fastingHistory: history,
    );
  }

  Future<void> toggleFasting() async {
    final box = Hive.box(boxName);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    List<DateTime> newHistory = [...state.fastingHistory];
    int newStreak = state.streak;

    if (state.isFastingToday) {
      newHistory.removeWhere((d) => d.isAtSameMomentAs(today));
      newStreak = (newStreak > 0) ? newStreak - 1 : 0;
    } else {
      newHistory.add(today);
      // Simple streak logic: if yesterday was in history, increment streak
      final yesterday = today.subtract(const Duration(days: 1));
      if (state.fastingHistory.any((d) => d.isAtSameMomentAs(yesterday))) {
        newStreak++;
      } else {
        newStreak = 1;
      }
    }

    await box.put(historyKey, newHistory.map((d) => d.toIso8601String()).toList());
    await box.put(streakKey, newStreak);

    state = FastingState(
      isFastingToday: !state.isFastingToday,
      streak: newStreak,
      fastingHistory: newHistory,
    );
  }
}

final fastingProvider = StateNotifierProvider<FastingNotifier, FastingState>((ref) {
  return FastingNotifier();
});
