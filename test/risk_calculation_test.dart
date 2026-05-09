import 'package:flutter_test/flutter_test.dart';
import 'package:qalb/features/risk_prediction/domain/entities/health_profile.dart';
import 'package:qalb/features/risk_prediction/domain/entities/risk_result.dart';
import 'package:qalb/features/risk_prediction/domain/usecases/calculate_risk_usecase.dart';

void main() {
  late CalculateRiskUseCase useCase;

  setUp(() {
    useCase = CalculateRiskUseCase();
  });

  group('Risk Calculation Tests', () {
    test('All factors 0 should result in score 0', () {
      final profile = HealthProfile(
        id: '1',
        userId: 'user1',
        age: 20,
        sex: 'Male',
        cholesterol: 150,
        systolicBP: 110,
        diastolicBP: 70,
        heartRate: 70,
        diabetes: false,
        familyHistory: false,
        smoking: false,
        obesity: false,
        alcoholConsumption: false,
        exerciseHoursPerWeek: 5.0,
        diet: 'Healthy',
        previousHeartProblems: false,
        medicationUse: false,
        stressLevel: 2,
        sedentaryHoursPerDay: 2.0,
        bmi: 22.0,
        triglycerides: 100,
        physicalActivityDaysPerWeek: 5,
        sleepHoursPerDay: 8,
        createdAt: DateTime.now(),
      );

      final result = useCase.execute(profile);
      expect(result.score, 0);
      expect(result.category, RiskCategory.low);
    });

    test('Low risk profile should result in score <= 25', () {
      final profile = HealthProfile(
        id: '2',
        userId: 'user1',
        age: 36, // +6
        sex: 'Male',
        cholesterol: 180,
        systolicBP: 125, // +6
        diastolicBP: 80,
        heartRate: 75,
        diabetes: false,
        familyHistory: false,
        smoking: false,
        obesity: false,
        alcoholConsumption: false,
        exerciseHoursPerWeek: 4.0,
        diet: 'Average', // +4
        previousHeartProblems: false,
        medicationUse: false,
        stressLevel: 3,
        sedentaryHoursPerDay: 4.0,
        bmi: 24.0,
        triglycerides: 120,
        physicalActivityDaysPerWeek: 3,
        sleepHoursPerDay: 7,
        createdAt: DateTime.now(),
      );
      // Total expected: 6 + 6 + 4 = 16

      final result = useCase.execute(profile);
      expect(result.score, lessThanOrEqualTo(25));
      expect(result.category, RiskCategory.low);
    });

    test('High risk profile should result in score > 75', () {
      final profile = HealthProfile(
        id: '3',
        userId: 'user1',
        age: 65, // +20
        sex: 'Male',
        cholesterol: 250, // +12
        systolicBP: 170, // +18
        diastolicBP: 100,
        heartRate: 110, // +8
        diabetes: true, // +14
        familyHistory: true, // +12
        smoking: true, // +18
        obesity: true,
        alcoholConsumption: true, // +6
        exerciseHoursPerWeek: 0.0, // +8
        diet: 'Unhealthy', // +8
        previousHeartProblems: true, // +20
        medicationUse: true,
        stressLevel: 9, // +8
        sedentaryHoursPerDay: 10.0, // +6
        bmi: 36.0, // +10
        triglycerides: 250, // +8
        physicalActivityDaysPerWeek: 0,
        sleepHoursPerDay: 5, // +4
        createdAt: DateTime.now(),
      );
      // Total score will be clamped to 100

      final result = useCase.execute(profile);
      expect(result.score, greaterThan(75));
      expect(result.category, RiskCategory.veryHigh);
    });
  });
}
