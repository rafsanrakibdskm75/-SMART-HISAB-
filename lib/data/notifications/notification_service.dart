/// Local notifications display layer (flutter_local_notifications).
/// WHAT to show comes from the pure planner (domain/stage6.dart); this
/// class only schedules and displays. Device-verified in Stage 7.
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/stage6.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  int _seq = 0;

  Future<void> init() async {
    // v1.0.0 never initialised the timezone database, so tz.local stayed
    // UTC and the "9:30 PM Dhaka" reminder fired at 3:30 AM. Pin Dhaka.
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(settings: const InitializationSettings(android: android));
    // Android 13+ needs the runtime notification permission.
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _ready = true;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          'smart_hisab_reminders', 'Smart Hisab Reminders',
          channelDescription: 'Daily closing, overdue and stock reminders',
          importance: Importance.high, priority: Priority.high,
        ),
      );

  Future<void> showNow(ReminderItem item) async {
    if (!_ready) await init();
    // Unique id per notification: v1.0.0 reused one id per kind, so e.g.
    // the Robi low-stock alert replaced the Grameenphone one.
    await _plugin.show(
      id: 1000 + (++_seq), title: item.title, body: item.body,
      notificationDetails: _details,
    );
  }

  /// Daily closing reminder at the owner's chosen time.
  Future<void> scheduleDailyClosing({required int hour, required int minute}) async {
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw ArgumentError('Invalid reminder time: $hour:$minute');
    }
    if (!_ready) await init();
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (when.isBefore(now)) when = when.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id: 100,
      title: 'দৈনিক হিসাবের সময় হয়েছে',
      body: 'আজকের হিসাব মিলিয়ে দিন close করুন — কালকের opening ঠিক থাকবে।',
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyClosing() => _plugin.cancel(id: 100);
}
