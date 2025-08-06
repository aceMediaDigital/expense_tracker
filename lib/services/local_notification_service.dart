/* =======================================================
 *
 * Created by anele on 31/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;

  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialised => _isInitialized;


  /// Request Permissions
  Future<void> requestPermissions() async {
    await notificationPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await notificationPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true,);
  }


  /// Initialise Plugin
  Future<void> initNotification() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initAndroidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initIOSSettings = DarwinInitializationSettings(
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestSoundPermission: true
    );

    const InitializationSettings iniSettings = InitializationSettings(android: initAndroidSettings, iOS: initIOSSettings);

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await notificationPlugin.initialize(iniSettings);
    _isInitialized = true;
  }


  /// Notification Details Setup
  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notification',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high
      ),
      iOS: DarwinNotificationDetails()
    );
  }

  /// Show Notification
  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    return notificationPlugin.show(id, title, body,  notificationDetails());
  }


  /// Private: Schedule a single notification at a specific time
  Future<void> _scheduleAtTime({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }


  /// Public: Schedule two evening reminders
  Future<void> scheduleEveningReminders() async {
    await _scheduleAtTime(
      id: 1,
      hour: 20,
      minute: 30,
      title: 'Evening Reminder',
      body: 'Did you buy anything today?',
    );

    await _scheduleAtTime(
      id: 2,
      hour: 21,
      minute: 30,
      title: 'Final Reminder',
      body: 'Don’t forget to track your spending!',
    );
  }

  /// Schedule daily notification at 20:33
  Future<void> scheduleDailyNotification({
    int id = 0,
    String? title = 'Daily Reminder',
    String? body = 'This is your 20:33 notification',
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year,
      now.month, now.day,
      21, 34,
    );

    // If 20:33 already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),

      /// Make notification repeat daily
      matchDateTimeComponents: DateTimeComponents.time,

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      /// IOS Specific
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

  }

  //

  Future<void> cancelAllNotifications() async {
    return await notificationPlugin.cancelAll();
  }

}
