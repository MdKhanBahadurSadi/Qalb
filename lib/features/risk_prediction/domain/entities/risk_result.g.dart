// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RiskResultImpl _$$RiskResultImplFromJson(Map<String, dynamic> json) =>
    _$RiskResultImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      score: (json['score'] as num).toInt(),
      category: $enumDecode(_$RiskCategoryEnumMap, json['category']),
      topRiskFactors: (json['topRiskFactors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$RiskResultImplToJson(_$RiskResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'score': instance.score,
      'category': _$RiskCategoryEnumMap[instance.category]!,
      'topRiskFactors': instance.topRiskFactors,
      'recommendations': instance.recommendations,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };

const _$RiskCategoryEnumMap = {
  RiskCategory.low: 'low',
  RiskCategory.moderate: 'moderate',
  RiskCategory.high: 'high',
  RiskCategory.veryHigh: 'veryHigh',
};
