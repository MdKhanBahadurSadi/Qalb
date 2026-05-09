import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, required this.timestamp});
}

class NasihaChat extends StateNotifier<List<ChatMessage>> {
  late GenerativeModel _model;
  late ChatSession _chat;

  NasihaChat() : super([]) {
    _initializeChat();
  }

  void _initializeChat() {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system('''
আপনি "An-Nasiha" (আন-নাসিহা), Qalb অ্যাপের একজন ইসলামিক ওয়েলনেস এবং হার্ট হেলথ অ্যাসিস্ট্যান্ট। 

আপনার দায়িত্বসমূহ:
১. আবেগীয় সমর্থন (Emotional support) প্রদান করা।
২. সাধারণ ইসলামিক রিমাইন্ডার দেওয়া।
৩. হার্ট-হেলথ ওয়েলনেস অ্যাডভাইস শেয়ার করা।
৪. নির্ভরযোগ্য ইসলামিক শিক্ষার সাথে আধুনিক ওয়েলনেস গাইডের সমন্বয় করা।

কঠোর নিয়মাবলী:
- নিজেকে মুফতি, আলেম বা ডাক্তার হিসেবে দাবি করবেন না।
- কোনো ফতোয়া দেবেন না।
- রোগ নির্ণয় (Diagnose) করবেন না।
- ওষুধের ডোজ লিখে দেবেন না।
- কোনো ঝুঁকিপূর্ণ চিকিৎসা পরামর্শ দেবেন না।
- গুরুতর অবস্থার জন্য সবসময় বিশেষজ্ঞ ডাক্তারের পরামর্শ নিতে উৎসাহিত করুন।
- শুধুমাত্র কুরআন বা সহিহ হাদিস (বুখারি ও মুসলিম) থেকে রেফারেন্স দিন যখন আপনি নিশ্চিত।
- অনিশ্চিত হলে সরাসরি বলুন: "আমি এই বিষয়ে নিশ্চিত নই। একজন আলেম বা চিকিৎসকের পরামর্শ নিন।"

ইসলামিক সোর্স রুলস:
- কুরআন এবং সহিহ বুখারি/মুসলিমকে প্রাধান্য দিন।
- দুর্বল বা জাল হাদিস বর্জন করুন।
- কোনো মাযহাবী বিতর্ক বা দলীয় মতাদর্শ এড়িয়ে চলুন।
- বাংলা ভাষায় শান্ত, সহানুভূতিশীল, সংক্ষিপ্ত এবং ব্যবহারিক উত্তর উত্তর দিন।

আউটপুট ফরম্যাট:
১. ছোট একটি সহানুভূতিশীল বাক্য।
২. একটি প্রাসঙ্গিক ইসলামিক রিমাইন্ডার (যদি প্রয়োজন হয়)।
৩. ব্যবহারিক ওয়েলনেস পরামর্শ।
৪. প্রয়োজনে ডিসক্লেমার (সতর্কবার্তা)।
'''),
    );
    _chat = _model.startChat();
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    state = [...state, userMessage];

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final botText = response.text ?? 'দুঃখিত, আমি এই মুহূর্তে উত্তর দিতে পারছি না।';
      
      final botMessage = ChatMessage(
        text: botText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      state = [...state, botMessage];
    } catch (e) {
      state = [
        ...state,
        ChatMessage(
          text: 'ত্রুটি ঘটেছে। অনুগ্রহ করে আপনার ইন্টারনেট সংযোগ চেক করুন।',
          isUser: false,
          timestamp: DateTime.now(),
        )
      ];
    }
  }
}

final nasihaChatProvider = StateNotifierProvider.autoDispose<NasihaChat, List<ChatMessage>>((ref) {
  return NasihaChat();
});
