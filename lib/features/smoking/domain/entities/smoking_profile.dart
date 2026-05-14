import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qalb/core/constants/app_constants.dart';

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
    @Default(AppConstants.defaultPackagePrice) double packagePrice,
  }) = _SmokingProfile;

  factory SmokingProfile.fromJson(Map<String, dynamic> json) => _$SmokingProfileFromJson(json);
}
