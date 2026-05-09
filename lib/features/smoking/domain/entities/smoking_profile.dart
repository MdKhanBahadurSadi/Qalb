import 'package:freezed_annotation/freezed_annotation.dart';

part 'smoking_profile.freezed.dart';
part 'smoking_profile.g.dart';

@freezed
class SmokingProfile with _$SmokingProfile {
  const factory SmokingProfile({
    @Default(false) bool isCurrentSmoker,
    @Default(0) int cigarettesPerDay,
    @Default(0) int yearsSmoked,
    DateTime? quitDate,
    @Default(false) bool isInRecovery,
    @Default(15.0) double packagePrice,
  }) = _SmokingProfile;

  factory SmokingProfile.fromJson(Map<String, dynamic> json) => _$SmokingProfileFromJson(json);
}
