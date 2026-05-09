import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/islamic/domain/entities/prayer_time.dart';

class PrayerService {
  List<PrayerTime> calculatePrayerTimes(Position position) {
    final coordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final now = DateTime.now();
    final prayerTimes = PrayerTimes.today(coordinates, params);
    
    // For next day Fajr if all prayers today are passed
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowPrayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(tomorrow),
      params,
    );

    final List<Map<String, dynamic>> prayerData = [
      {'name': 'ফজর', 'arabic': 'الفجر', 'time': prayerTimes.fajr, 'icon': '🌅'},
      {'name': 'সূর্যোদয়', 'arabic': 'الشروق', 'time': prayerTimes.sunrise, 'icon': '☀️'},
      {'name': 'যোহর', 'arabic': 'الظهر', 'time': prayerTimes.dhuhr, 'icon': '🌤️'},
      {'name': 'আসর', 'arabic': 'العصر', 'time': prayerTimes.asr, 'icon': '🌇'},
      {'name': 'মাগরিব', 'arabic': 'المغرب', 'time': prayerTimes.maghrib, 'icon': '🌙'},
      {'name': 'এশা', 'arabic': 'العشاء', 'time': prayerTimes.isha, 'icon': '🌌'},
    ];

    int nextIndex = -1;
    for (int i = 0; i < prayerData.length; i++) {
      if (now.isBefore(prayerData[i]['time'])) {
        nextIndex = i;
        break;
      }
    }

    return List.generate(prayerData.length, (index) {
      final data = prayerData[index];
      DateTime time = data['time'];
      bool isNext = index == nextIndex;
      
      // If all passed, tomorrow's Fajr is next
      if (nextIndex == -1 && data['name'] == 'ফজর') {
        time = tomorrowPrayerTimes.fajr;
        isNext = true;
      }

      return PrayerTime(
        name: data['name'],
        arabicName: data['arabic'],
        time: time,
        isNext: isNext,
        isPassed: now.isAfter(time) && nextIndex != -1,
        icon: data['icon'],
      );
    });
  }

  PrayerTime? getCurrentPrayer(List<PrayerTime> prayers) {
    final now = DateTime.now();
    for (int i = prayers.length - 1; i >= 0; i--) {
      if (now.isAfter(prayers[i].time)) {
        return prayers[i];
      }
    }
    return null;
  }
}
