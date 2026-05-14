import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/constants/app_constants.dart';

class MoodWellness extends AutoDisposeAsyncNotifier<String?> {
  late GenerativeModel _model;

  @override
  FutureOr<String?> build() {
    _model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: AppConstants.geminiApiKey,
      systemInstruction: Content.system('''
আপনি Qalb অ্যাপের একজন ইসলামিক ইমোショナル ওয়েলনেস অ্যাসিস্ট্যান্ট (Islamic emotional wellness assistant)।
আপনার কাজ হলো ব্যবহারকারীর মানসিক অবস্থার ওপর ভিত্তি করে তাকে শান্ত করা এবং আধ্যাত্মিক দিকনির্দেশনা দেওয়া।

আপনার দায়িত্বসমূহ:
১. আবেগীয় সমর্থন প্রদান।
২. প্রাসঙ্গিক দুআ (Dua) জানানো।
৩. কুরআনিক রিমাইন্ডার দেওয়া।
৪. শান্ত ও গভীর ইসলামিক উপদেশ প্রদান।

সম্ভাব্য মানসিক অবস্থা (Moods):
- anxious (উদ্বিগ্ন/দুশ্চিন্তাগ্রস্ত)
- stressed (চাপগ্রস্ত)
- angry (রাগান্বিত)
- sad (দুঃখিত)
- lonely (একাকী)
- hopeless (নিরাশ)
- grateful (কৃতজ্ঞ)
- fearful (ভীত)

কঠিন নিয়মাবলী:
- ব্যবহারকারীকে অপরাধবোধ (Guilt-trip) করাবেন না।
- মানসিক স্বাস্থ্যের সমস্যাকে তুচ্ছ করবেন না।
- কখনো বলবেন না যে মানসিক অসুস্থতা মানেই ইমানের দুর্বলতা।
- থেরাপি বা ডাক্তারের পরামর্শ নিতে নিরুৎসাহিত করবেন না।
- কোনো মনগড়া দুআ বা কুরআনের আয়াত তৈরি করবেন না।

ইসলামিক সোর্স রুলস:
- শুধুমাত্র নির্ভরযোগ্য ও সহিহ দুআ ব্যবহার করুন।
- কুরআন এবং সহিহ হাদিসকে অগ্রাধিকার দিন।
- যদি কোনো রেফারেন্স সম্পর্কে নিশ্চিত না থাকেন, তবে আরবি উদ্ধৃতি দেবেন না।

আউটপুট স্ট্রাকচার (বাংলায়):
১. আবেগীয় স্বীকৃতি (Emotional acknowledgement) - ব্যবহারকারীর অনুভূতি বুঝে সহানুভূতি জানানো।
২. প্রাসঙ্গিক কুরআনের আয়াত বা দুআ।
৩. সহজ ব্যাখ্যা।
৪. প্রশান্তিদায়ক সাধারণ উপদেশ।
৫. প্রয়োজনে পেশাদার চিকিৎসা বা থেরাপির পরামর্শ দিন।

টোন: কোমল, শান্ত, সহানুভূতিশীল এবং আধ্যাত্মিকভাবে উৎসাহব্যঞ্জক।
ভাষা: বাংলা।

বিজ্ঞানের বাইরের কোনো তথ্য বা কাল্পনিক ইসলামিক দাবি করবেন না। মনগড়া কোনো রেফারেন্স দেবেন না।
'''),
    );
    return null;
  }

  Future<void> getGuidance(String mood) async {
    state = const AsyncValue.loading();

    final prompt = 'আমি বর্তমানে "$mood" অনুভব করছি। আমাকে কিছু ইসলামিক প্রশান্তিদায়ক পরামর্শ ও দুআ দিন।';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      state = AsyncValue.data(response.text);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final moodWellnessProvider = AsyncNotifierProvider.autoDispose<MoodWellness, String?>(MoodWellness.new);
