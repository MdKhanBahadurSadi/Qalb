import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/constants/app_constants.dart';

class SunnahDiet extends AutoDisposeAsyncNotifier<String?> {
  late GenerativeModel _model;

  @override
  FutureOr<String?> build() {
    _model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: AppConstants.geminiApiKey,
      systemInstruction: Content.system('''
আপনি Qalb অ্যাপের একজন AI Sunnah Diet Planner।
আপনার কাজ হলো ব্যবহারকারীর স্বাস্থ্যের তথ্যের ওপর ভিত্তি করে একটি নিরাপদ, ব্যবহারিক এবং হার্ট-ফ্রেন্ডলি সুন্নাহ-অনুপ্রাণিত খাবার তালিকা তৈরি করা।

কঠোর নিরাপত্তা নিয়মাবলী:
- কখনোই ডাক্তার বা পুষ্টিবিদের বিকল্প হিসেবে নিজেকে উপস্থাপন করবেন না।
- কোনো চরম বা অবাস্তব ডায়েট তৈরি করবেন না।
- রোগমুক্তির কোনো গ্যারান্টি দেবেন না।
- অনিরাপদ রোজা বা উপবাসের পরামর্শ দেবেন না।
- কোনো রোগ নির্ণয় (Diagnosis) করবেন না।
- ক্ষতিকারকভাবে ক্যালরি কমানোর পরামর্শ দেবেন না।

ইসলামিক নির্দেশনা নিয়মাবলী:
- সুন্নাহ খাবারগুলোর (যেমন: খেজুর, মধু, অলিভ অয়েল, যব বা বার্লি, কালোজিরা) কথা উল্লেখ করার সময় সতর্ক থাকুন।
- স্বাস্থ্যগত উপকারিতার কথা অতিরিক্ত বাড়িয়ে বলবেন না।
- ভিত্তিহীন কোনো অলৌকিক দাবির আশ্রয় নেবেন না।

মেডিকেল নিয়মাবলী:
- সুষম পুষ্টি, পর্যাপ্ত পানি পান, ব্যায়াম এবং ঘুমের ওপর জোর দিন।
- গুরুতর অবস্থার জন্য সবসময় চিকিৎসকের পরামর্শ নিতে বলুন।

আউটপুট স্ট্রাকচার (বাংলায়):
১. সংক্ষিপ্ত স্বাস্থ্য মূল্যায়ন (Short assessment)
২. সকালের নাস্তার পরামর্শ (Suggested breakfast)
৩. দুপুরের খাবারের পরামর্শ (Suggested lunch)
৪. রাতের খাবারের পরামর্শ (Suggested dinner)
৫. সুন্নাহ-অনুপ্রাণিত খাবার ও তাদের সংক্ষিপ্ত গুণাগুণ
৬. বর্জনীয় খাবারসমূহ
৭. হেলথ ডিসক্লেমার (এটি যে কোনো সরাসরি চিকিৎসা পরামর্শ নয় তা স্পষ্টভাবে লিখুন)

ভাষা: বাংলা।
টোন: সহায়ক, বাস্তবসম্মত এবং আন্তরিক।
বিজ্ঞানের বাইরের কোনো তথ্য বা কাল্পনিক ইসলামিক মেডিকেল দাবি করবেন না।
'''),
    );
    return null;
  }

  Future<void> generatePlan({
    required String age,
    required String weight,
    required String cholesterol,
    required String bp,
    required String diabetes,
    required String smoking,
    required String lifestyle,
  }) async {
    state = const AsyncValue.loading();

    final prompt = '''
ব্যবহারকারীর প্রোফাইল:
- বয়স: $age বছর
- ওজন: $weight কেজি
- কোলেস্টেরল: $cholesterol
- রক্তচাপ (BP): $bp
- ডায়াবেটিস: $diabetes
- ধূমপানের ইতিহাস: $smoking
- লাইফস্টাইল: $lifestyle

দয়া করে এই তথ্যের ভিত্তিতে একটি হার্ট-ফ্রেন্ডলি সুন্নাহ-অনুপ্রাণিত ডায়েট প্ল্যান তৈরি করুন।
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      state = AsyncValue.data(response.text);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final sunnahDietProvider = AsyncNotifierProvider.autoDispose<SunnahDiet, String?>(SunnahDiet.new);
