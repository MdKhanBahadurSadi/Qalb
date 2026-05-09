import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_result.freezed.dart';
part 'risk_result.g.dart';

enum RiskCategory { low, moderate, high, veryHigh }

@freezed
class RiskResult with _$RiskResult {
  const factory RiskResult({
    required String id,
    required String userId,
    required int score, // 0-100
    required RiskCategory category,
    required List<String> topRiskFactors,
    required List<String> recommendations,
    required DateTime calculatedAt,
  }) = _RiskResult;

  factory RiskResult.fromJson(Map<String, dynamic> json) =>
      _$RiskResultFromJson(json);
}
