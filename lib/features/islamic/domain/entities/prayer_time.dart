import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_time.freezed.dart';

@freezed
class PrayerTime with _$PrayerTime {
  const factory PrayerTime({
    required String name,
    required String arabicName,
    required DateTime time,
    required bool isNext,
    required bool isPassed,
    required String icon,
  }) = _PrayerTime;
}
