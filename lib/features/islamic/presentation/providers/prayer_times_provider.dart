import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart';
import '../../domain/entities/prayer_time.dart';
import '../../data/services/prayer_service.dart';
import '../../../../core/services/location_service.dart';

final prayerServiceProvider = Provider((ref) => PrayerService());
final locationServiceProvider = Provider((ref) => LocationService());

final locationProvider = FutureProvider<Position?>((ref) async {
  final service = ref.read(locationServiceProvider);
  try {
    return await service.getCurrentLocation();
  } catch (e) {
    debugPrint('Location Provider Error: $e');
    return null; // Fallback to null, which then triggers Dhaka defaults in consumers
  }
});

final prayerTimesProvider = Provider<AsyncValue<List<PrayerTime>>>((ref) {
  final locationAsync = ref.watch(locationProvider);
  final service = ref.read(prayerServiceProvider);

  List<PrayerTime> buildList(double lat, double lon) {
    debugPrint('Running Adhan calculation for Lat: $lat, Lon: $lon');
    final adhanTimes = service.getPrayerTimes(lat, lon);
    final nextPrayer = adhanTimes.nextPrayer();
    final now = DateTime.now();

    return [
      PrayerTime(
        name: 'ফজর',
        arabicName: 'الفجر',
        time: adhanTimes.fajr,
        isNext: nextPrayer == Prayer.fajr,
        isPassed: now.isAfter(adhanTimes.fajr),
        icon: '🌅',
      ),
      PrayerTime(
        name: 'যোহর',
        arabicName: 'الظهر',
        time: adhanTimes.dhuhr,
        isNext: nextPrayer == Prayer.dhuhr,
        isPassed: now.isAfter(adhanTimes.dhuhr),
        icon: '☀️',
      ),
      PrayerTime(
        name: 'আসর',
        arabicName: 'العصر',
        time: adhanTimes.asr,
        isNext: nextPrayer == Prayer.asr,
        isPassed: now.isAfter(adhanTimes.asr),
        icon: '🌇',
      ),
      PrayerTime(
        name: 'মাগরিব',
        arabicName: 'المغرب',
        time: adhanTimes.maghrib,
        isNext: nextPrayer == Prayer.maghrib,
        isPassed: now.isAfter(adhanTimes.maghrib),
        icon: '🌙',
      ),
      PrayerTime(
        name: 'এশা',
        arabicName: 'العشاء',
        time: adhanTimes.isha,
        isNext: nextPrayer == Prayer.isha,
        isPassed: now.isAfter(adhanTimes.isha),
        icon: '🌌',
      ),
    ];
  }

  return locationAsync.when(
    data: (pos) {
      try {
        // Dhaka coordinates as ultimate fallback
        final lat = pos?.latitude ?? 23.8103;
        final lon = pos?.longitude ?? 90.4125;
        return AsyncValue.data(buildList(lat, lon));
      } catch (e) {
        debugPrint('Calculation Error: $e');
        return AsyncValue.data(buildList(23.8103, 90.4125));
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (e, _) {
      debugPrint('Location Async Error: $e');
      return AsyncValue.data(buildList(23.8103, 90.4125));
    },
  );
});

final currentPrayerStatusProvider = Provider<Map<String, dynamic>?>((ref) {
  final locationAsync = ref.watch(locationProvider);
  final service = ref.read(prayerServiceProvider);
  
  final pos = locationAsync.value;
  final lat = pos?.latitude ?? 23.8103;
  final lon = pos?.longitude ?? 90.4125;
  
  try {
    final adhanTimes = service.getPrayerTimes(lat, lon);
    final current = adhanTimes.currentPrayer();
    if (current == Prayer.none) return null;
    
    return {
      'name': service.getPrayerNameBengali(current),
      'time': service.formatTime(adhanTimes.timeForPrayer(current)!),
    };
  } catch (_) {
    return null;
  }
});

final nextPrayerStatusProvider = Provider<Map<String, dynamic>?>((ref) {
  final prayerTimesAsync = ref.watch(prayerTimesProvider);
  final service = ref.read(prayerServiceProvider);

  return prayerTimesAsync.maybeWhen(
    data: (prayers) {
      try {
        final next = prayers.firstWhere((p) => p.isNext);
        return {
          'name': next.name,
          'time': service.formatTime(next.time),
          'dateTime': next.time,
        };
      } catch (_) {
        final fajr = prayers.firstWhere((p) => p.name == 'ফজর');
        return {
          'name': 'ফজর',
          'time': service.formatTime(fajr.time),
          'dateTime': fajr.time.add(const Duration(days: 1)),
        };
      }
    },
    orElse: () => null,
  );
});

final prayerCountdownProvider = StreamProvider.autoDispose<String>((ref) {
  final nextPrayer = ref.watch(nextPrayerStatusProvider);
  final service = ref.read(prayerServiceProvider);

  if (nextPrayer == null) return Stream.value('--:--:--');
  final targetTime = nextPrayer['dateTime'] as DateTime;

  return Stream.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now();
    final remaining = targetTime.difference(now);
    
    if (remaining.isNegative) {
      ref.invalidate(locationProvider);
      return '00:00:00';
    }
    return service.formatDuration(remaining);
  });
});
