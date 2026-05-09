import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/health_profile.dart';
import '../../domain/entities/risk_result.dart';
import '../../domain/usecases/calculate_risk_usecase.dart';
import '../../domain/repositories/i_risk_repository.dart';
import '../../data/repositories/risk_repository_impl.dart';
import 'package:uuid/uuid.dart';

final riskRepositoryProvider = Provider<IRiskRepository>((ref) {
  return RiskRepositoryImpl();
});

class RiskResultState {
  final AsyncValue<RiskResult?> result;
  RiskResultState({this.result = const AsyncValue.data(null)});
}

class RiskResultNotifier extends StateNotifier<AsyncValue<RiskResult?>> {
  final IRiskRepository _repository;
  final CalculateRiskUseCase _calculateUseCase = CalculateRiskUseCase();

  RiskResultNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> calculateAndSave(Map<String, dynamic> formData, String userId) async {
    state = const AsyncValue.loading();
    try {
      // Create HealthProfile from form data
      final profile = HealthProfile(
        id: const Uuid().v4(),
        userId: userId,
        age: formData['age'] ?? 25,
        sex: formData['sex'] ?? 'Male',
        cholesterol: formData['cholesterol'] ?? 200,
        systolicBP: formData['systolicBP'] ?? 120,
        diastolicBP: formData['diastolicBP'] ?? 80,
        heartRate: formData['heartRate'] ?? 72,
        triglycerides: formData['triglycerides'] ?? 150,
        smoking: formData['smoking'] ?? false,
        alcoholConsumption: formData['alcoholConsumption'] ?? false,
        exerciseHoursPerWeek: formData['exerciseHoursPerWeek'] ?? 3.0,
        sedentaryHoursPerDay: formData['sedentaryHoursPerDay'] ?? 8.0,
        physicalActivityDaysPerWeek: formData['physicalActivityDaysPerWeek'] ?? 3,
        sleepHoursPerDay: formData['sleepHoursPerDay'] ?? 7,
        stressLevel: formData['stressLevel'] ?? 5,
        diet: formData['diet'] ?? 'Average',
        diabetes: formData['diabetes'] ?? false,
        familyHistory: formData['familyHistory'] ?? false,
        previousHeartProblems: formData['previousHeartProblems'] ?? false,
        medicationUse: formData['medicationUse'] ?? false,
        obesity: formData['obesity'] ?? false,
        bmi: _calculateBMI(formData['height'] ?? 170.0, formData['weight'] ?? 70.0),
        createdAt: DateTime.now(),
      );

      // Save Profile
      await _repository.saveHealthProfile(profile);

      // Calculate Result
      final result = _calculateUseCase.execute(profile);

      // Save Result
      await _repository.saveRiskResult(result);

      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  double _calculateBMI(double heightCm, double weightKg) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
}

final riskResultProvider =
    StateNotifierProvider.autoDispose<RiskResultNotifier, AsyncValue<RiskResult?>>((ref) {
  return RiskResultNotifier(ref.watch(riskRepositoryProvider));
});
