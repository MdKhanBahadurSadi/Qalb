import '../entities/health_profile.dart';
import '../entities/risk_result.dart';
import 'package:uuid/uuid.dart';

class CalculateRiskUseCase {
  RiskResult execute(HealthProfile p) {
    final Map<String, int> factors = {};

    // Calculate score and track factors
    int ageScore = 0;
    if (p.age >= 60) {
      ageScore = 20;
    } else if (p.age >= 45) {
      ageScore = 12;
    } else if (p.age >= 35) {
      ageScore = 6;
    }
    if (ageScore > 0) {
      factors['বয়স (${p.age})'] = ageScore;
    }

    int bpScore = 0;
    if (p.systolicBP > 160) {
      bpScore = 18;
    } else if (p.systolicBP > 140) {
      bpScore = 12;
    } else if (p.systolicBP > 120) {
      bpScore = 6;
    }
    if (bpScore > 0) {
      factors['উচ্চ রক্তচাপ (${p.systolicBP}/${p.diastolicBP})'] = bpScore;
    }

    int cholScore = 0;
    if (p.cholesterol > 240) {
      cholScore = 12;
    } else if (p.cholesterol > 200) {
      cholScore = 7;
    }
    if (cholScore > 0) {
      factors['কোলেস্টেরল (${p.cholesterol} mg/dL)'] = cholScore;
    }

    if (p.heartRate > 100) {
      factors['অস্বাভাবিক হার্ট রেট (${p.heartRate} bpm)'] = 8;
    }

    int triScore = 0;
    if (p.triglycerides > 200) {
      triScore = 8;
    } else if (p.triglycerides > 150) {
      triScore = 4;
    }
    if (triScore > 0) {
      factors['ট্রাইগ্লিসারাইড (${p.triglycerides} mg/dL)'] = triScore;
    }

    if (p.smoking) {
      factors['ধূমপান'] = 18;
    }
    if (p.alcoholConsumption) {
      factors['মদ্যপান'] = 6;
    }
    if (p.exerciseHoursPerWeek < 2) {
      factors['শারীরিক পরিশ্রমের অভাব'] = 8;
    }
    if (p.sedentaryHoursPerDay > 8) {
      factors['দীর্ঘক্ষণ বসে থাকা'] = 6;
    }
    if (p.sleepHoursPerDay < 6 || p.sleepHoursPerDay > 9) {
      factors['অনিয়মিত ঘুম'] = 4;
    }

    int stressScore = 0;
    if (p.stressLevel >= 8) {
      stressScore = 8;
    } else if (p.stressLevel >= 6) {
      stressScore = 4;
    }
    if (stressScore > 0) {
      factors['মানসিক চাপ (লেভেল ${p.stressLevel})'] = stressScore;
    }

    int dietScore = 0;
    if (p.diet == 'Unhealthy') {
      dietScore = 8;
    } else if (p.diet == 'Average') {
      dietScore = 4;
    }
    if (dietScore > 0) {
      factors['অস্বাস্থ্যকর খাদ্যাভ্যাস'] = dietScore;
    }

    int bmiScore = 0;
    if (p.bmi > 35) {
      bmiScore = 10;
    } else if (p.bmi > 30) {
      bmiScore = 6;
    }
    if (bmiScore > 0) {
      factors['অতিরিক্ত ওজন (BMI: ${p.bmi.toStringAsFixed(1)})'] = bmiScore;
    }

    if (p.diabetes) {
      factors['ডায়াবেটিস'] = 14;
    }
    if (p.familyHistory) {
      factors['পরিবারে হার্টের রোগের ইতিহাস'] = 12;
    }
    if (p.previousHeartProblems) {
      factors['পুরানো হার্টের সমস্যা'] = 20;
    }

    int totalScore = factors.values.fold(0, (sum, val) => sum + val);
    totalScore = totalScore.clamp(0, 100);

    final category = _getCategory(totalScore);

    // Sort and get top factors
    final sortedFactors = factors.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topFactors = sortedFactors.take(3).map((e) => e.key).toList();

    return RiskResult(
      id: const Uuid().v4(),
      userId: p.userId,
      score: totalScore,
      category: category,
      topRiskFactors: topFactors,
      recommendations: _generateRecommendations(p, totalScore),
      calculatedAt: DateTime.now(),
    );
  }

  RiskCategory _getCategory(int score) {
    if (score <= 25) return RiskCategory.low;
    if (score <= 50) return RiskCategory.moderate;
    if (score <= 75) return RiskCategory.high;
    return RiskCategory.veryHigh;
  }

  List<String> _generateRecommendations(HealthProfile p, int score) {
    final List<String> recs = [];

    if (p.smoking) {
      recs.add('ধূমপান অবিলম্বে ত্যাগ করুন। নবী (সাঃ) বলেছেন: "নিজের ক্ষতি করো না এবং অন্যের ক্ষতি করো না।" (ইবনে মাজাহ)');
    }
    if (p.systolicBP > 140) {
      recs.add('লবণ খাওয়া কমিয়ে দিন এবং নিয়মিত রক্তচাপ চেক করুন।');
    }
    if (p.bmi > 30) {
      recs.add('ওজন কমানোর চেষ্টা করুন। পরিমিত আহার সুন্নাহ।');
    }
    if (p.diabetes) {
      recs.add('রক্তের শর্করা নিয়ন্ত্রণে রাখুন এবং নিয়মিত হাঁটাহাঁটি করুন।');
    }
    if (p.exerciseHoursPerWeek < 3) {
      recs.add('প্রতিদিন অন্তত ৩০ মিনিট দ্রুত হাঁটার অভ্যাস করুন।');
    }
    if (p.stressLevel >= 7) {
      recs.add('বেশি করে জিকির ও তিলাওয়াত করুন। "আল্লাহর জিকিরেই অন্তর প্রশান্ত হয়।" (আল-কুরআন)');
    }

    if (recs.isEmpty) {
      recs.add('স্বাস্থ্যকর জীবনধারা বজায় রাখুন এবং নিয়মিত চেকআপ করুন।');
    }

    return recs;
  }
}
