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

    final initializationSettings = InitializationSettings(
      android: _androidSettings(),
      linux: _linuxSettings(),
    );

    await _plugin.initialize(initializationSettings);
  }

  AndroidInitializationSettings _androidSettings() {
    return const AndroidInitializationSettings('@mipmap/ic_launcher');
  }

  LinuxInitializationSettings _linuxSettings() {
    return const LinuxInitializationSettings(
      defaultActionName: 'Open',
    );
  }

  Future<void> showDailyQuoteNow({
    required String title,
    required String body,
  }) async {
    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        'daily_quote',
        'Daily Quote',
        channelDescription: 'Daily philosophy quote',
        importance: Importance.max,
        priority: Priority.high,
      ),
      linux: const LinuxNotificationDetails(),
    );

    await _plugin.show(
      1,
      title,
      body,
      details,
    );
  }

  Future<void> scheduleDailyAt({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        'daily_quote',
        'Daily Quote',
        channelDescription: 'Daily philosophy quote',
        importance: Importance.max,
        priority: Priority.high,
      ),
      linux: const LinuxNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      2,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
