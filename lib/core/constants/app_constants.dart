import 'secrets.dart';

class AppConstants {
  static const appName = 'Qalb';
  static const appVersion = '1.0.0';
  static const firestoreUsersCollection = 'users';
  static const firestoreReportsCollection = 'reports';
  static const hiveSettingsBox = 'settings';
  static const hiveHealthBox = 'health_data';
  static const hiveSmokingBox = 'smoking_data';
  static const hiveDhikrBox = 'dhikr_data';
  
  // AI Config
  static const geminiApiKey = Secrets.geminiApiKey;
  static const geminiModel = 'gemini-3.1-flash-lite';

  static const defaultCigarettePrice = 20.0; // BDT
  static const defaultPackagePrice = defaultCigarettePrice * 20; // 20 sticks per pack
  static const medicalDisclaimer = "⚠️ এই অ্যাপটি শুধুমাত্র তথ্যমূলক সহায়তার জন্য। এটি কোনোভাবেই পেশাদার চিকিৎসা পরামর্শের বিকল্প নয়।";
}
