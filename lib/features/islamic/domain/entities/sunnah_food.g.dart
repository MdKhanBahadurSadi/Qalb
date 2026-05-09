// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sunnah_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SunnahFoodImpl _$$SunnahFoodImplFromJson(Map<String, dynamic> json) =>
    _$SunnahFoodImpl(
      id: json['id'] as String,
      nameBangla: json['nameBangla'] as String,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      hadithBangla: json['hadithBangla'] as String,
      hadithSource: json['hadithSource'] as String,
      heartBenefits: (json['heartBenefits'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scientificBasis: json['scientificBasis'] as String,
      howToConsume: json['howToConsume'] as String,
      caution: json['caution'] as String?,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$$SunnahFoodImplToJson(_$SunnahFoodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameBangla': instance.nameBangla,
      'nameArabic': instance.nameArabic,
      'nameEnglish': instance.nameEnglish,
      'hadithBangla': instance.hadithBangla,
      'hadithSource': instance.hadithSource,
      'heartBenefits': instance.heartBenefits,
      'scientificBasis': instance.scientificBasis,
      'howToConsume': instance.howToConsume,
      'caution': instance.caution,
      'emoji': instance.emoji,
    };
