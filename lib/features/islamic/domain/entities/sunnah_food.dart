import 'package:freezed_annotation/freezed_annotation.dart';

part 'sunnah_food.freezed.dart';
part 'sunnah_food.g.dart';

@freezed
class SunnahFood with _$SunnahFood {
  const factory SunnahFood({
    required String id,
    required String nameBangla,
    required String nameArabic,
    required String nameEnglish,
    required String hadithBangla,
    required String hadithSource,
    required List<String> heartBenefits,
    required String scientificBasis,
    required String howToConsume,
    String? caution,
    required String emoji,
  }) = _SunnahFood;

  factory SunnahFood.fromJson(Map<String, dynamic> json) => _$SunnahFoodFromJson(json);
}
