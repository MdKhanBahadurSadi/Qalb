import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerService {
  PrayerTimes getPrayerTimes(double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    
    return PrayerTimes.today(coordinates, params);
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  String getPrayerNameBengali(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'ফজর';
      case Prayer.sunrise:
        return 'সূর্যোদয়';
      case Prayer.dhuhr:
        return 'যোহর';
      case Prayer.asr:
        return 'আসর';
      case Prayer.maghrib:
        return 'মাগরিব';
      case Prayer.isha:
        return 'এশা';
      case Prayer.none:
        return 'নেই';
    }
  }

  Duration getRemainingTime(DateTime nextPrayerTime) {
    final now = DateTime.now();
    if (nextPrayerTime.isBefore(now)) {
      // If the time has passed (e.g. counting to tomorrow's Fajr), 
      // the logic in the provider should handle adding a day.
      return Duration.zero;
    }
    return nextPrayerTime.difference(now);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
