import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linux = LinuxInitializationSettings(defaultActionName: 'Open');

    const settings = InitializationSettings(
      android: android,
      linux: linux,
    );

    await _plugin.initialize(settings);
  }

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
      1001,
      "Hourly Reflection",
      "Pause and reflect for a moment.",
      RepeatInterval.hourly,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // ✅ THIS METHOD WAS MISSING
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
