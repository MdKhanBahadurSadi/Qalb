import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthProfileFormState {
  final int currentStep;
  final int age;
  final String sex;
  final int heightFeet;
  final int heightInches;
  final double weight; // in kg
  final int systolicBP;
  final int diastolicBP;
  final int cholesterol;
  final int heartRate;
  final bool smoking;
  final bool diabetes;
  final bool familyHistory;

  HealthProfileFormState({
    this.currentStep = 0,
    this.age = 25,
    this.sex = 'Male',
    this.heightFeet = 5,
    this.heightInches = 7,
    this.weight = 70.0,
    this.systolicBP = 120,
    this.diastolicBP = 80,
    this.cholesterol = 200,
    this.heartRate = 72,
    this.smoking = false,
    this.diabetes = false,
    this.familyHistory = false,
  });

  double get heightInCm {
    return (heightFeet * 30.48) + (heightInInches * 2.54);
  }

  int get heightInInches => (heightFeet * 12) + heightInches;

  double get bmi {
    final heightInMeters = heightInCm / 100;
    if (heightInMeters <= 0) return 0;
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
    int? heightFeet,
    int? heightInInches,
    int? heightInches,
    double? weight,
    int? systolicBP,
    int? diastolicBP,
    int? cholesterol,
    int? heartRate,
    bool? smoking,
    bool? diabetes,
    bool? familyHistory,
  }) {
    return HealthProfileFormState(
      currentStep: currentStep ?? this.currentStep,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      weight: weight ?? this.weight,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
      cholesterol: cholesterol ?? this.cholesterol,
      heartRate: heartRate ?? this.heartRate,
      smoking: smoking ?? this.smoking,
      diabetes: diabetes ?? this.diabetes,
      familyHistory: familyHistory ?? this.familyHistory,
    );
  }
}

class HealthProfileFormNotifier extends StateNotifier<HealthProfileFormState> {
  HealthProfileFormNotifier() : super(HealthProfileFormState());

  void updateField({
    int? age,
    String? sex,
    int? heightFeet,
    int? heightInches,
    double? weight,
    int? systolicBP,
    int? diastolicBP,
    int? cholesterol,
    int? heartRate,
    bool? smoking,
    bool? diabetes,
    bool? familyHistory,
  }) {
    state = state.copyWith(
      age: age,
      sex: sex,
      heightFeet: heightFeet,
      heightInches: heightInches,
      weight: weight,
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      cholesterol: cholesterol,
      heartRate: heartRate,
      smoking: smoking,
      diabetes: diabetes,
      familyHistory: familyHistory,
    );
  }

  void nextStep() {
    if (state.currentStep < 2) {
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
