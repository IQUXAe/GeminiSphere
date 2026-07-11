import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logger/logger.dart';
import '../../../core/errors/exceptions.dart';

class NotificationDataSource {
  static const String _channelId = 'gemini_sphere_alerts';
  static const String _channelName = 'GeminiSphere Alerts';
  static const String _channelDescription = 'Timer and alarm notifications';

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      // Initialize AlarmManager for reliable Android delivery
      await AndroidAlarmManager.initialize();
    }

    _initialized = true;
    _logger.i('[Notifications] Initialized');
  }

  Future<void> scheduleTimerNotification({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_initialized) await initialize();

    try {
      await _notifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'timer:$notificationId',
      );
      _logger.i('[Notifications] Scheduled timer notification #$notificationId at $scheduledTime');
    } catch (e) {
      throw StorageException('Failed to schedule notification: $e');
    }
  }

  Future<void> cancelNotification(int notificationId) async {
    await _notifications.cancel(notificationId);
    _logger.i('[Notifications] Cancelled notification #$notificationId');
  }

  Future<void> showImmediateNotification({
    required int notificationId,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await initialize();
    await _notifications.show(
      notificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'immediate:$notificationId',
    );
  }
}
