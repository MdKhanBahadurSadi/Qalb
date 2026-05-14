import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/tflite_service.dart';
import '../../../../core/services/gemini_service.dart';
import '../../domain/entities/risk_result.dart';
import 'health_profile_form_provider.dart';

final tfliteServiceProvider = Provider((ref) => TFLiteService());
final geminiServiceProvider = Provider((ref) => GeminiService());

final riskPredictionProvider = StateNotifierProvider<RiskPredictionNotifier, AsyncValue<double>>((ref) {
  final tfliteService = ref.watch(tfliteServiceProvider);
  final geminiService = ref.watch(geminiServiceProvider);
  final healthState = ref.watch(healthProfileFormProvider);
  return RiskPredictionNotifier(tfliteService, geminiService, healthState);
});

class RiskPredictionNotifier extends StateNotifier<AsyncValue<double>> {
  final TFLiteService _tfliteService;
  final GeminiService _geminiService;
  final HealthProfileFormState _healthState;

  RiskPredictionNotifier(this._tfliteService, this._geminiService, this._healthState) : super(const AsyncValue.data(0.0));

  Future<void> calculateRisk() async {
    state = const AsyncValue.loading();
    try {
      await _tfliteService.initialize();
      
      // Normalized Input
      final input = [
        (_healthState.age - 20) / (80 - 20),
        (_healthState.cholesterol - 100) / (400 - 100),
        (_healthState.systolicBP - 80) / (200 - 80),
        (_healthState.diastolicBP - 50) / (120 - 50),
        (_healthState.heartRate - 40) / (150 - 40),
        (_healthState.bmi - 10) / (50 - 10),
        _healthState.diabetes ? 1.0 : 0.0,
        _healthState.familyHistory ? 1.0 : 0.0,
        _healthState.smoking ? 1.0 : 0.0,
      ].map((e) => e.clamp(0.0, 1.0)).toList();

      final result = _tfliteService.predict(input);
      
      // Save Result to History (with AI recommendations)
      await _saveResultWithAI(result);
      
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> _saveResultWithAI(double score) async {
    final box = Hive.box(AppConstants.hiveHealthBox);
    final percentage = (score * 100).clamp(0.0, 100.0).toInt();
    
    final category = percentage < 20 
        ? RiskCategory.low 
        : percentage < 50 
            ? RiskCategory.moderate 
            : RiskCategory.high;

    // 1. Get Static Recommendations first as fallback
    List<String> recommendations = _getRecommendations(category);

    // 2. Try to get AI Recommendations
    try {
      final aiRecommendations = await _geminiService.generateHealthRecommendations(
        age: _healthState.age,
        bmi: _healthState.bmi,
        systolicBP: _healthState.systolicBP,
        score: percentage,
        riskCategory: category.name,
      );
      if (aiRecommendations.isNotEmpty) {
        recommendations = aiRecommendations;
      }
    } catch (_) {
      // Keep static recommendations if AI fails
    }

    final riskResult = RiskResult(
      id: const Uuid().v4(),
      userId: 'current_user', 
      score: percentage,
      category: category,
      topRiskFactors: _getTopFactors(),
      recommendations: recommendations,
      calculatedAt: DateTime.now(),
    );

    await box.add(riskResult.toJson());
  }

  List<String> _getTopFactors() {
    List<String> factors = [];
    if (_healthState.smoking) factors.add('ধূমপান');
    if (_healthState.bmi > 25) factors.add('অতিরিক্ত ওজন (BMI)');
    if (_healthState.systolicBP > 140) factors.add('উচ্চ রক্তচাপ');
    if (_healthState.diabetes) factors.add('ডায়াবেটিস');
    return factors;
  }

  List<String> _getRecommendations(RiskCategory category) {
    if (category == RiskCategory.low) {
      return ['স্বাস্থ্যকর জীবনযাপন অব্যাহত রাখুন।', 'নিয়মিত ব্যায়াম করুন।'];
    } else if (category == RiskCategory.moderate) {
      return ['লবণ ও চিনি কম খান।', 'প্রতিদিন ৩০ মিনিট হাঁটুন।', 'চিকিৎসকের পরামর্শ নিন।'];
    } else {
      return ['দ্রুত হৃদরোগ বিশেষজ্ঞের পরামর্শ নিন।', 'ধূমপান বর্জন করুন।', 'রক্তচাপ নিয়ন্ত্রণে রাখুন।'];
    }
  }
}
