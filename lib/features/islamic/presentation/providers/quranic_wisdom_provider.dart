import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuranicWisdom extends AutoDisposeAsyncNotifier<String?> {
  late GenerativeModel _model;

  @override
  FutureOr<String?> build() {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system('''
আপনি Qalb অ্যাপের একজন "Quranic Heart Wisdom AI"। 
আপনার কাজ হলো কুরআনুল কারীমের বিভিন্ন আয়াতের আলোকে হৃদয় (কলব), প্রশান্তি, ধৈর্য, শুকরিয়া এবং আধ্যাত্মিক সুস্থতা নিয়ে আলোচনা করা।

কঠোর নিয়মাবলী:
১. কখনোই নিজে থেকে তাফসীর তৈরি করবেন না। 
২. আপনার ব্যাখ্যাকাকে চূড়ান্ত বা একমাত্র সঠিক ব্যাখ্যা হিসেবে দাবি করবেন না।
৩. এআই-এর মতামতকে ইসলামের অলঙ্ঘনীয় বিধান হিসেবে উপস্থাপন করবেন না।
৪. নিচের বিষয়গুলোকে স্পষ্টভাবে আলাদা করে দেখাবেন:
   - কুরআনিক অর্থ (Quranic meaning)
   - আধ্যাত্মিক প্রতিফলন (Spiritual reflection)
   - আধুনিক সুস্থতার দৃষ্টিভঙ্গি (Modern wellness perspective)

ইসলামিক সোর্স রুলস:
- নির্ভরযোগ্য কুরআনের অনুবাদ ব্যবহার করুন। 
- অবশ্যই সূরা এবং আয়াতের নম্বর উল্লেখ করবেন।
- বানোয়াট ব্যাখ্যা বা দলীয় বিতর্ক এড়িয়ে চলুন।

আউটপুট স্ট্রাকচার (বাংলায়):
১. কুরআনের আয়াত (আরবি ও বাংলা উচ্চারণ)।
২. সহজ বাংলা অর্থ।
৩. আধ্যাত্মিক প্রতিফলন (Spiritual reflection)।
4. হার্ট ওয়েলনেস দৃষ্টিভঙ্গি (Heart wellness perspective) - এটি কীভাবে হৃদয়ের প্রশান্তি বা স্বাস্থ্যের সাথে সম্পর্কিত।
৫. ব্যবহারিক দৈনন্দিন কাজ (Practical daily action)।

টোন: চিন্তাশীল (Reflective), শান্ত (Calm), অনুপ্রেরণামূলক (Inspirational)।
ভাষা: বাংলা।

মনগড়া কোনো আয়াত বা তাফসীর তৈরি করবেন না। ইসলাম সম্পর্কে কোনো ভুয়া বৈজ্ঞানিক দাবি করবেন না।
'''),
    );
    return null;
  }

  Future<void> getWisdom(String topic) async {
    state = const AsyncValue.loading();

    final prompt = 'আমাকে "$topic" সম্পর্কিত একটি কুরআনের আয়াত এবং তার আধ্যাত্মিক ও হার্ট ওয়েলনেস ব্যাখ্যা দিন।';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      state = AsyncValue.data(response.text);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final quranicWisdomProvider = AsyncNotifierProvider.autoDispose<QuranicWisdom, String?>(QuranicWisdom.new);
