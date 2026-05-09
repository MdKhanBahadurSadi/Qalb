import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/health_profile.dart';
import '../../domain/entities/risk_result.dart';
import '../../domain/repositories/i_risk_repository.dart';

class RiskRepositoryImpl implements IRiskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveHealthProfile(HealthProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.userId)
        .collection('health_profiles')
        .doc(profile.id)
        .set(profile.toJson());
  }

  @override
  Future<HealthProfile?> getLatestHealthProfile(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('health_profiles')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return HealthProfile.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<void> saveRiskResult(RiskResult result) async {
    await _firestore
        .collection('users')
        .doc(result.userId)
        .collection('risk_results')
        .doc(result.id)
        .set(result.toJson());
  }

  @override
  Future<RiskResult?> getLatestRiskResult(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('risk_results')
        .orderBy('calculatedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return RiskResult.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<List<RiskResult>> getRiskHistory(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('risk_results')
        .orderBy('calculatedAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => RiskResult.fromJson(doc.data()))
        .toList();
  }
}
