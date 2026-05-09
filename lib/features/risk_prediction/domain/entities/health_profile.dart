import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_profile.freezed.dart';
part 'health_profile.g.dart';

@freezed
class HealthProfile with _$HealthProfile {
  const factory HealthProfile({
    required String id,
    required String userId,
    required int age,
    required String sex, // 'Male' / 'Female'
    required int cholesterol, // mg/dL
    required int systolicBP,
    required int diastolicBP,
    required int heartRate, // bpm
    required bool diabetes,
    required bool familyHistory,
    required bool smoking,
    required bool obesity,
    required bool alcoholConsumption,
    required double exerciseHoursPerWeek,
    required String diet, // 'Healthy' / 'Average' / 'Unhealthy'
    required bool previousHeartProblems,
    required bool medicationUse,
    required int stressLevel, // 1-10
    required double sedentaryHoursPerDay,
    required double bmi,
    required int triglycerides,
    required int physicalActivityDaysPerWeek,
    required int sleepHoursPerDay,
    required DateTime createdAt,
  }) = _HealthProfile;

  factory HealthProfile.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileFromJson(json);
}
