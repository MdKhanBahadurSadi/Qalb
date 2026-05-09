import '../entities/health_profile.dart';
import '../entities/risk_result.dart';

abstract class IRiskRepository {
  Future<void> saveHealthProfile(HealthProfile profile);
  Future<HealthProfile?> getLatestHealthProfile(String userId);
  Future<void> saveRiskResult(RiskResult result);
  Future<RiskResult?> getLatestRiskResult(String userId);
  Future<List<RiskResult>> getRiskHistory(String userId);
}
