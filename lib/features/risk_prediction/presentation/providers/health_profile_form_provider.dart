import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthProfileFormState {
  final int currentStep;
  final int age;
  final String sex;
  final double height; // in cm
  final double weight; // in kg
  final int systolicBP;
  final int diastolicBP;
  final int cholesterol;
  final int heartRate;
  final int triglycerides;
  final bool smoking;
  final bool alcoholConsumption;
  final double exerciseHoursPerWeek;
  final double sedentaryHoursPerDay;
  final int physicalActivityDaysPerWeek;
  final int sleepHoursPerDay;
  final int stressLevel;
  final String diet;
  final bool diabetes;
  final bool familyHistory;
  final bool previousHeartProblems;
  final bool medicationUse;
  final bool obesity;

  HealthProfileFormState({
    this.currentStep = 0,
    this.age = 25,
    this.sex = 'Male',
    this.height = 170.0,
    this.weight = 70.0,
    this.systolicBP = 120,
    this.diastolicBP = 80,
    this.cholesterol = 200,
    this.heartRate = 72,
    this.triglycerides = 150,
    this.smoking = false,
    this.alcoholConsumption = false,
    this.exerciseHoursPerWeek = 3.0,
    this.sedentaryHoursPerDay = 8.0,
    this.physicalActivityDaysPerWeek = 3,
    this.sleepHoursPerDay = 7,
    this.stressLevel = 5,
    this.diet = 'Average',
    this.diabetes = false,
    this.familyHistory = false,
    this.previousHeartProblems = false,
    this.medicationUse = false,
    this.obesity = false,
  });

  double get bmi {
    if (height <= 0) return 0;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final val = bmi;
    if (val < 18.5) return 'কম ওজন';
    if (val < 25) return 'স্বাভাবিক';
    if (val < 30) return 'বেশি ওজন';
    return 'স্থূলকায়';
  }

  HealthProfileFormState copyWith({
    int? currentStep,
    int? age,
    String? sex,
    double? height,
    double? weight,
    int? systolicBP,
    int? diastolicBP,
    int? cholesterol,
    int? heartRate,
    int? triglycerides,
    bool? smoking,
    bool? alcoholConsumption,
    double? exerciseHoursPerWeek,
    double? sedentaryHoursPerDay,
    int? physicalActivityDaysPerWeek,
    int? sleepHoursPerDay,
    int? stressLevel,
    String? diet,
    bool? diabetes,
    bool? familyHistory,
    bool? previousHeartProblems,
    bool? medicationUse,
    bool? obesity,
  }) {
    return HealthProfileFormState(
      currentStep: currentStep ?? this.currentStep,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      cholesterol: cholesterol ?? this.cholesterol,
      heartRate: heartRate ?? this.heartRate,
      triglycerides: triglycerides ?? this.triglycerides,
      smoking: smoking ?? this.smoking,
      alcoholConsumption: alcoholConsumption ?? this.alcoholConsumption,
      exerciseHoursPerWeek: exerciseHoursPerWeek ?? this.exerciseHoursPerWeek,
      sedentaryHoursPerDay: sedentaryHoursPerDay ?? this.sedentaryHoursPerDay,
      physicalActivityDaysPerWeek: physicalActivityDaysPerWeek ?? this.physicalActivityDaysPerWeek,
      sleepHoursPerDay: sleepHoursPerDay ?? this.sleepHoursPerDay,
      stressLevel: stressLevel ?? this.stressLevel,
      diet: diet ?? this.diet,
      diabetes: diabetes ?? this.diabetes,
      familyHistory: familyHistory ?? this.familyHistory,
      previousHeartProblems: previousHeartProblems ?? this.previousHeartProblems,
      medicationUse: medicationUse ?? this.medicationUse,
      obesity: obesity ?? this.obesity,
    );
  }
}

class HealthProfileFormNotifier extends StateNotifier<HealthProfileFormState> {
  HealthProfileFormNotifier() : super(HealthProfileFormState());

  void updateField({
    int? age,
    String? sex,
    double? height,
    double? weight,
    int? systolicBP,
    int? diastolicBP,
    int? cholesterol,
    int? heartRate,
    int? triglycerides,
    bool? smoking,
    bool? alcoholConsumption,
    double? exerciseHoursPerWeek,
    double? sedentaryHoursPerDay,
    int? physicalActivityDaysPerWeek,
    int? sleepHoursPerDay,
    int? stressLevel,
    String? diet,
    bool? diabetes,
    bool? familyHistory,
    bool? previousHeartProblems,
    bool? medicationUse,
    bool? obesity,
  }) {
    state = state.copyWith(
      age: age,
      sex: sex,
      height: height,
      weight: weight,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      cholesterol: cholesterol,
      heartRate: heartRate,
      triglycerides: triglycerides,
      smoking: smoking,
      alcoholConsumption: alcoholConsumption,
      exerciseHoursPerWeek: exerciseHoursPerWeek,
      sedentaryHoursPerDay: sedentaryHoursPerDay,
      physicalActivityDaysPerWeek: physicalActivityDaysPerWeek,
      sleepHoursPerDay: sleepHoursPerDay,
      stressLevel: stressLevel,
      diet: diet,
      diabetes: diabetes,
      familyHistory: familyHistory,
      previousHeartProblems: previousHeartProblems,
      medicationUse: medicationUse,
      obesity: obesity,
    );
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}

final healthProfileFormProvider =
    StateNotifierProvider.autoDispose<HealthProfileFormNotifier, HealthProfileFormState>((ref) {
  return HealthProfileFormNotifier();
});
