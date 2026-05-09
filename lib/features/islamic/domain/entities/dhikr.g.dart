// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DhikrImpl _$$DhikrImplFromJson(Map<String, dynamic> json) => _$DhikrImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      arabic: json['arabic'] as String,
      bangla: json['bangla'] as String,
      translation: json['translation'] as String,
      targetCount: (json['targetCount'] as num).toInt(),
      healthBenefit: json['healthBenefit'] as String,
      currentCount: (json['currentCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DhikrImplToJson(_$DhikrImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'arabic': instance.arabic,
      'bangla': instance.bangla,
      'translation': instance.translation,
      'targetCount': instance.targetCount,
      'healthBenefit': instance.healthBenefit,
      'currentCount': instance.currentCount,
    };
