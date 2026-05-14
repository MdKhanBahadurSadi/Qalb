import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:developer' as dev;

class GeminiService {
  late GenerativeModel _model;
  
  GeminiService() {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<List<String>> generateHealthRecommendations({
    required int age,
    required double bmi,
    required int systolicBP,
    required int score,
    required String riskCategory,
  }) async {
    try {
      final prompt = '''
আমি একটি ইসলামিক হার্ট হেলথ অ্যাপ "Qalb" এর জন্য কাজ করছি। 
নিম্নলিখিত স্বাস্থ্য তথ্যের ভিত্তিতে ৩-৪টি সংক্ষিপ্ত এবং ব্যবহারিক পরামর্শ (Bullet points) তৈরি করুন:
- বয়স: $age বছর
- BMI: ${bmi.toStringAsFixed(1)}
- সিস্টোলিক রক্তচাপ: $systolicBP mmHg
- হার্ট অ্যাটাক রিস্ক স্কোর: $score% ($riskCategory)

পরামর্শগুলো অবশ্যই বাংলা ভাষায় হতে হবে এবং এতে প্রয়োজনে একটি ছোট ইসলামিক অনুপ্রেরণা (যেমন: স্বাস্থ্য আল্লাহর নেয়ামত) থাকতে পারে। 
পরামর্শগুলো খুব সংক্ষিপ্ত এবং সরাসরি হতে হবে। শুধুমাত্র পয়েন্টগুলো দিন।
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text != null && text.isNotEmpty) {
        // Split by new lines and clean up bullet points
        return text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceFirst(RegExp(r'^[*\-\d.\s]+'), '').trim())
            .toList();
      }
    } catch (e) {
      dev.log('❌ Gemini Recommendation Error: $e');
    }
    return []; // Return empty if failed
  }
}
