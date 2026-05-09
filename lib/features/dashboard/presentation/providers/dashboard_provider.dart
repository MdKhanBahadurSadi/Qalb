import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../risk_prediction/domain/entities/risk_result.dart';
import '../../../risk_prediction/presentation/providers/risk_result_provider.dart';

class DashboardData {
  final RiskResult? latestResult;
  final String userName;

  DashboardData({
    this.latestResult,
    required this.userName,
  });
}

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final user = ref.watch(currentUserProvider);
  final repository = ref.watch(riskRepositoryProvider);
  
  RiskResult? latestResult;
  if (user != null) {
    latestResult = await repository.getLatestRiskResult(user.id);
  }

  return DashboardData(
    latestResult: latestResult,
    userName: user?.name ?? 'ইউজার',
  );
});
