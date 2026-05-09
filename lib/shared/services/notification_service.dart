import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    try {
      tz.initializeTimeZones();
      
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
      
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tap
        },
      );
    } catch (e) {
      print('Notification Initialization Error: $e');
    }
  }

  static Future<void> schedulePrayerNotifications(Map<String, DateTime> prayers) async {
    for (var entry in prayers.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;
      
      final scheduledTime = prayerTime.subtract(const Duration(minutes: 15));
      if (scheduledTime.isBefore(DateTime.now())) continue;

      try {
        await _notifications.zonedSchedule(
          prayerName.hashCode,
          'নামাজের সময় হচ্ছে 🕌',
          '$prayerName - ${prayerTime.hour.toString().padLeft(2, '0')}:${prayerTime.minute.toString().padLeft(2, '0')}',
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'prayer_channel', 
              'Prayer Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        print('Error scheduling notification: $e');
      }
    }
  }

  static Future<void> scheduleDailyHealthTip() async {
    try {
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, 9, 0);
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        1001,
        'আজকের স্বাস্থ্য টিপস 🌿',
        'আপনার হৃদপিণ্ডের যত্নে আজ নিয়মিত হাঁটার অভ্যাস করুন।',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_tip_channel', 
            'Daily Health Tips',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Error scheduling daily tip: $e');
    }
  }

  static Future<void> showSmokingMilestone(String milestone) async {
    await _notifications.show(
      2001,
      'মাশাআল্লাহ! নতুন মাইলস্টোন 🏆',
      milestone,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'milestone_channel', 
          'Milestones',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
