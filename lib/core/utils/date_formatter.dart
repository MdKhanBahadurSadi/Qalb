import 'package:hijri/hijri_calendar.dart';

class DateFormatter {
  static const _banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  static const _banglaMonths = [
    'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
    'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
  ];

  static String toBanglaDate(DateTime date) {
    final day = toBanglaNumber(date.day);
    final month = _banglaMonths[date.month - 1];
    final year = toBanglaNumber(date.year);
    return '$day $month $year';
  }

  static String toBanglaNumber(int number) {
    final s = number.toString();
    var res = '';
    for (var i = 0; i < s.length; i++) {
      final digit = int.tryParse(s[i]);
      if (digit != null) {
        res += _banglaDigits[digit];
      } else {
        res += s[i];
      }
    }
    return res;
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 30) return toBanglaDate(date);
    if (diff.inDays >= 1) return '${toBanglaNumber(diff.inDays)} দিন আগে';
    if (diff.inHours >= 1) return '${toBanglaNumber(diff.inHours)} ঘণ্টা আগে';
    if (diff.inMinutes >= 1) return '${toBanglaNumber(diff.inMinutes)} মিনিট আগে';
    return 'এইমাত্র';
  }

  static String toHijriDate(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return '${toBanglaNumber(hijri.hDay)} ${hijri.longMonthName}, ${toBanglaNumber(hijri.hYear)} হিজরি';
  }
}
