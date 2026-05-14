import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/risk_result.dart';

final healthHistoryProvider = StreamProvider<List<RiskResult>>((ref) async* {
  final box = Hive.box(AppConstants.hiveHealthBox);
  
  // Yield initial data
  yield box.values
      .map((e) => RiskResult.fromJson(Map<String, dynamic>.from(e)))
      .toList()
      .reversed
      .toList();

  // Yield new data whenever the box changes
  await for (final _ in box.watch()) {
    yield box.values
        .map((e) => RiskResult.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }
});
