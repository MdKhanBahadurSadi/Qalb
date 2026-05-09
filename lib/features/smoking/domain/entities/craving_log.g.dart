// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'craving_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CravingLogImpl _$$CravingLogImplFromJson(Map<String, dynamic> json) =>
    _$CravingLogImpl(
      intensity: (json['intensity'] as num).toDouble(),
      triggers:
          (json['triggers'] as List<dynamic>).map((e) => e as String).toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      resolved: json['resolved'] as bool? ?? false,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$CravingLogImplToJson(_$CravingLogImpl instance) =>
    <String, dynamic>{
      'intensity': instance.intensity,
      'triggers': instance.triggers,
      'timestamp': instance.timestamp.toIso8601String(),
      'resolved': instance.resolved,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };
