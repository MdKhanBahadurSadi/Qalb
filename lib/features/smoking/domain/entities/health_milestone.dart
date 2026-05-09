import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_milestone.freezed.dart';

@freezed
class HealthMilestone with _$HealthMilestone {
  const factory HealthMilestone({
    required String title,
    required Duration timeAfterQuitting,
    @Default(false) bool isAchieved,
    DateTime? achievedAt,
  }) = _HealthMilestone;

  static List<HealthMilestone> get defaultMilestones => [
        const HealthMilestone(
          title: '২০ মিনিট: রক্তচাপ ও হার্ট রেট স্বাভাবিক হয়',
          timeAfterQuitting: Duration(minutes: 20),
        ),
        const HealthMilestone(
          title: '১২ ঘণ্টা: রক্তে কার্বন মনোক্সাইড কমে',
          timeAfterQuitting: Duration(hours: 12),
        ),
        const HealthMilestone(
          title: '২৪ ঘণ্টা: হার্ট অ্যাটাকের ঝুঁকি কমতে শুরু',
          timeAfterQuitting: Duration(hours: 24),
        ),
        const HealthMilestone(
          title: '৪৮ ঘণ্টা: গন্ধ ও স্বাদ ফিরে আসে',
          timeAfterQuitting: Duration(hours: 48),
        ),
        const HealthMilestone(
          title: '২ সপ্তাহ: রক্ত সঞ্চালন উন্নত হয়',
          timeAfterQuitting: Duration(days: 14),
        ),
        const HealthMilestone(
          title: '১ মাস: ফুসফুসের কার্যক্ষমতা বাড়ে',
          timeAfterQuitting: Duration(days: 30),
        ),
        const HealthMilestone(
          title: '৩ মাস: হৃদরোগের ঝুঁকি অর্ধেক কমে',
          timeAfterQuitting: Duration(days: 90),
        ),
        const HealthMilestone(
          title: '১ বছর: হৃদরোগের ঝুঁকি ধূমপায়ীর অর্ধেক',
          timeAfterQuitting: Duration(days: 365),
        ),
      ];
}
