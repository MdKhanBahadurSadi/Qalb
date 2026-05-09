// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smoking_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmokingProfileImpl _$$SmokingProfileImplFromJson(Map<String, dynamic> json) =>
    _$SmokingProfileImpl(
      isCurrentSmoker: json['isCurrentSmoker'] as bool? ?? false,
      cigarettesPerDay: (json['cigarettesPerDay'] as num?)?.toInt() ?? 0,
      yearsSmoked: (json['yearsSmoked'] as num?)?.toInt() ?? 0,
      quitDate: json['quitDate'] == null
          ? null
          : DateTime.parse(json['quitDate'] as String),
      isInRecovery: json['isInRecovery'] as bool? ?? false,
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 15.0,
    );

Map<String, dynamic> _$$SmokingProfileImplToJson(
        _$SmokingProfileImpl instance) =>
    <String, dynamic>{
      'isCurrentSmoker': instance.isCurrentSmoker,
      'cigarettesPerDay': instance.cigarettesPerDay,
      'yearsSmoked': instance.yearsSmoked,
      'quitDate': instance.quitDate?.toIso8601String(),
      'isInRecovery': instance.isInRecovery,
      'packagePrice': instance.packagePrice,
    };
