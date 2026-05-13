import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/tflite_service.dart';
import 'health_profile_form_provider.dart';

final tfliteServiceProvider = Provider((ref) => TFLiteService());

final riskPredictionProvider = StateNotifierProvider<RiskPredictionNotifier, AsyncValue<double>>((ref) {
  final tfliteService = ref.watch(tfliteServiceProvider);
  final healthState = ref.watch(healthProfileFormProvider);
  return RiskPredictionNotifier(tfliteService, healthState);
});

class RiskPredictionNotifier extends StateNotifier<AsyncValue<double>> {
  final TFLiteService _tfliteService;
  final HealthProfileFormState _healthState;

  RiskPredictionNotifier(this._tfliteService, this._healthState) : super(const AsyncValue.data(0.0));

  Future<void> calculateRisk() async {
    state = const AsyncValue.loading();
    try {
      await _tfliteService.initialize();
      
      // Feature Mapping for TFLite:
      // 1. Age, 2. Cholesterol, 3. Systolic BP, 4. Diastolic BP, 5. Heart Rate, 6. BMI, 
      // 7. Diabetes (1/0), 8. Family History (1/0), 9. Smoking (1/0)
      
      final input = [
        _healthState.age.toDouble(),
        _healthState.cholesterol.toDouble(),
        _healthState.systolicBP.toDouble(),
        _healthState.diastolicBP.toDouble(),
        _healthState.heartRate.toDouble(),
        _healthState.bmi,
        _healthState.diabetes ? 1.0 : 0.0,
        _healthState.familyHistory ? 1.0 : 0.0,
        _healthState.smoking ? 1.0 : 0.0,
      ];

      final result = _tfliteService.predict(input);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
