// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthProfileImpl _$$HealthProfileImplFromJson(Map<String, dynamic> json) =>
    _$HealthProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      age: (json['age'] as num).toInt(),
      sex: json['sex'] as String,
      cholesterol: (json['cholesterol'] as num).toInt(),
      systolicBP: (json['systolicBP'] as num).toInt(),
      diastolicBP: (json['diastolicBP'] as num).toInt(),
      heartRate: (json['heartRate'] as num).toInt(),
      diabetes: json['diabetes'] as bool,
      familyHistory: json['familyHistory'] as bool,
      smoking: json['smoking'] as bool,
      obesity: json['obesity'] as bool,
      alcoholConsumption: json['alcoholConsumption'] as bool,
      exerciseHoursPerWeek: (json['exerciseHoursPerWeek'] as num).toDouble(),
      diet: json['diet'] as String,
      previousHeartProblems: json['previousHeartProblems'] as bool,
      medicationUse: json['medicationUse'] as bool,
      stressLevel: (json['stressLevel'] as num).toInt(),
      sedentaryHoursPerDay: (json['sedentaryHoursPerDay'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      triglycerides: (json['triglycerides'] as num).toInt(),
      physicalActivityDaysPerWeek:
          (json['physicalActivityDaysPerWeek'] as num).toInt(),
      sleepHoursPerDay: (json['sleepHoursPerDay'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HealthProfileImplToJson(_$HealthProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'age': instance.age,
      'sex': instance.sex,
      'cholesterol': instance.cholesterol,
      'systolicBP': instance.systolicBP,
      'diastolicBP': instance.diastolicBP,
      'heartRate': instance.heartRate,
      'diabetes': instance.diabetes,
      'familyHistory': instance.familyHistory,
      'smoking': instance.smoking,
      'obesity': instance.obesity,
      'alcoholConsumption': instance.alcoholConsumption,
      'exerciseHoursPerWeek': instance.exerciseHoursPerWeek,
      'diet': instance.diet,
      'previousHeartProblems': instance.previousHeartProblems,
      'medicationUse': instance.medicationUse,
      'stressLevel': instance.stressLevel,
      'sedentaryHoursPerDay': instance.sedentaryHoursPerDay,
      'bmi': instance.bmi,
      'triglycerides': instance.triglycerides,
      'physicalActivityDaysPerWeek': instance.physicalActivityDaysPerWeek,
      'sleepHoursPerDay': instance.sleepHoursPerDay,
      'createdAt': instance.createdAt.toIso8601String(),
    };
