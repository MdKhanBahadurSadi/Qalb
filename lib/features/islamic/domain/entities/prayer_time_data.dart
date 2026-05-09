import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_time_data.freezed.dart';

@freezed
class PrayerTimeData with _$PrayerTimeData {
  const factory PrayerTimeData({
    required String fajr,
    required String sunrise,
    required String dhuhr,
    required String asr,
    required String maghrib,
    required String isha,
    required DateTime date,
  }) = _PrayerTimeData;
}
