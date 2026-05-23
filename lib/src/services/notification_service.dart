import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../models/ingredient.dart';
import '../models/user_preferences.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  static const _androidChannelId = 'expiry_reminders';
  static const _androidChannelName = 'Expiry reminders';
  static const _androidChannelDescription =
      'Reminders for ingredients that are close to expiry.';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) {
      return;
    }

    timezone_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings: settings);
    await _requestPermissions();
    _isInitialized = true;
  }

  Future<void> scheduleExpiryReminders({
    required List<Ingredient> ingredients,
    required UserPreferences preferences,
  }) async {
    if (kIsWeb) {
      return;
    }

    try {
      await initialize();
      await _notifications.cancelAll();

      final upcomingIngredients = ingredients
          .where((ingredient) => ingredient.daysUntilExpiry >= 0)
          .take(50);

      for (final ingredient in upcomingIngredients) {
        final reminderDates = _reminderDatesFor(
          ingredient: ingredient,
          reminderDaysBefore: preferences.reminderDaysBefore,
          repeatCount: preferences.notificationRepeatCount,
          reminderHour: preferences.preferredReminderHour,
        );

        for (var index = 0; index < reminderDates.length; index += 1) {
          final reminderDate = reminderDates[index];

          await _notifications.zonedSchedule(
            id: _notificationIdFor(ingredient.id, index),
            title: 'Use ${ingredient.name} soon',
            body:
                '${ingredient.name} expires on ${_formatDate(ingredient.expiryDate)}.',
            scheduledDate: timezone.TZDateTime.from(
              reminderDate,
              timezone.local,
            ),
            notificationDetails: _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: ingredient.id,
          );
        }
      }
    } catch (_) {
      // Notification plugins are unavailable in widget tests and some desktop
      // runs. The app should continue working without blocking core features.
    }
  }

  Future<void> showTestNotification() async {
    if (kIsWeb) {
      return;
    }

    try {
      await initialize();
      await _notifications.show(
        id: 999001,
        title: 'EcoBite reminders are on',
        body: 'You will be reminded before ingredients expire.',
        notificationDetails: _notificationDetails(),
      );
    } catch (_) {
      // Keep notification setup non-blocking for unsupported environments.
    }
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      timezone.setLocalLocation(timezone.getLocation(timezoneInfo.identifier));
    } catch (_) {
      timezone.setLocalLocation(timezone.getLocation('UTC'));
    }
  }

  Future<void> _requestPermissions() async {
    final androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();

    final iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  List<DateTime> _reminderDatesFor({
    required Ingredient ingredient,
    required int reminderDaysBefore,
    required int repeatCount,
    required int reminderHour,
  }) {
    final dates = <DateTime>[];
    final expiryDay = DateTime(
      ingredient.expiryDate.year,
      ingredient.expiryDate.month,
      ingredient.expiryDate.day,
    );
    final remindersToCreate = repeatCount.clamp(1, 5).toInt();

    for (var index = 0; index < remindersToCreate; index += 1) {
      final daysBefore = (reminderDaysBefore - index).clamp(0, 365).toInt();
      final reminderDate = expiryDay
          .subtract(Duration(days: daysBefore))
          .add(Duration(hours: reminderHour.clamp(0, 23).toInt()));

      if (reminderDate.isAfter(DateTime.now())) {
        dates.add(reminderDate);
      }
    }

    final expiryEndOfDay = DateTime(
      ingredient.expiryDate.year,
      ingredient.expiryDate.month,
      ingredient.expiryDate.day,
      23,
      59,
    );
    final sameDayReminder = DateTime.now().add(const Duration(minutes: 1));

    if (dates.isEmpty && sameDayReminder.isBefore(expiryEndOfDay)) {
      dates.add(sameDayReminder);
    }

    return dates;
  }

  int _notificationIdFor(String ingredientId, int reminderIndex) {
    final baseId = ingredientId.hashCode.abs() % 2147480000;
    return baseId + reminderIndex;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
