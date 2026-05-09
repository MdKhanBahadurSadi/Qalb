class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'ইমেইল প্রয়োজন';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'সঠিক ইমেইল দিন';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'পাসওয়ার্ড প্রয়োজন';
    if (value.length < 6) return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) return 'বয়স প্রয়োজন';
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 120) return 'সঠিক বয়স দিন';
    return null;
  }

  static String? validateBP(String? value) {
    if (value == null || value.isEmpty) return 'রক্তচাপ প্রয়োজন';
    final bp = int.tryParse(value);
    if (bp == null || bp < 50 || bp > 250) return 'সঠিক মান দিন';
    return null;
  }

  static String? validateCholesterol(String? value) {
    if (value == null || value.isEmpty) return 'কোলেস্টেরল প্রয়োজন';
    final val = int.tryParse(value);
    if (val == null || val < 100 || val > 500) return 'সঠিক মান দিন';
    return null;
  }

  static String? validateRequired(String? value, {String message = 'এই তথ্যটি প্রয়োজন'}) {
    if (value == null || value.isEmpty) return message;
    return null;
  }
}
