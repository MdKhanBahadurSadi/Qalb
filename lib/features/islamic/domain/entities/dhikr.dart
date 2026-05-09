import 'package:freezed_annotation/freezed_annotation.dart';

part 'dhikr.freezed.dart';
part 'dhikr.g.dart';

@freezed
class Dhikr with _$Dhikr {
  const factory Dhikr({
    required String id,
    required String title,
    required String arabic,
    required String bangla,
    required String translation,
    required int targetCount,
    required String healthBenefit,
    @Default(0) int currentCount,
  }) = _Dhikr;

  factory Dhikr.fromJson(Map<String, dynamic> json) => _$DhikrFromJson(json);
}
