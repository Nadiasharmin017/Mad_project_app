import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linux = LinuxInitializationSettings(defaultActionName: 'Open');

    const settings = InitializationSettings(
      android: android,
      linux: linux,
    );

    await _plugin.initialize(settings);
  }

  /// ✅ Works on Linux + Android
  Future<void> showDailyQuoteNow({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_quote',
        'Daily Quote',
        channelDescription: 'Daily philosophy quote',
        importance: Importance.high,
        priority: Priority.high,
      ),
      linux: LinuxNotificationDetails(),
    );

    await _plugin.show(1001, title, body, details);
  }

  /// ✅ Only works on Android/iOS. On Linux it does nothing (prevents crash).
  Future<void> scheduleDailyAt({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_quote',
        'Daily Quote',
        channelDescription: 'Daily philosophy quote',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      1002,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// ✅ Hourly repeating notification (Android only)
  Future<void> enableHourlyNotifications() async {
    if (!Platform.isAndroid) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'hourly_channel',
        'Hourly Reflection',
        channelDescription: 'Hourly philosophy reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.periodicallyShow(
      5001,
      "Hourly Reflection",
      "Take 30 seconds to reflect.",
      RepeatInterval.hourly,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
