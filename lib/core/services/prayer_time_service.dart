import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/islamic/domain/entities/prayer_time.dart';

class PrayerTimeService {
  List<PrayerTime> calculatePrayerTimes(Position position) {
    final coordinates = Coordinates(position.latitude, position.longitude);
    
    // Setting: Karachi method & Hanafi madhab as requested
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;

    final now = DateTime.now();
    final prayerTimes = PrayerTimes.today(coordinates, params);
    
    // For counting down to tomorrow's Fajr if Isha is passed
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
      
      // Handle the case where all prayers today have passed
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

  double calculateQibla(Position position) {
    return Qibla(Coordinates(position.latitude, position.longitude)).direction;
  }
}
