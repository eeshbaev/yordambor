import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

typedef ReminderNotificationTapHandler = void Function(String reminderId);

class LocalNotificationService {
  LocalNotificationService._();

  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  ReminderNotificationTapHandler? _onReminderTap;
  String? _pendingLaunchReminderId;

  ReminderNotificationTapHandler? get onReminderTap => _onReminderTap;

  set onReminderTap(ReminderNotificationTapHandler? handler) {
    _onReminderTap = handler;
    if (handler != null && _pendingLaunchReminderId != null) {
      final id = _pendingLaunchReminderId!;
      _pendingLaunchReminderId = null;
      handler(id);
    }
  }

  static const _payloadPrefix = 'reminder:';

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tashkent'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _handlePayload(launchDetails!.notificationResponse?.payload);
    }

    _initialized = true;
  }

  void _onNotificationResponse(NotificationResponse response) {
    _handlePayload(response.payload);
  }

  void _handlePayload(String? payload) {
    if (payload == null || !payload.startsWith(_payloadPrefix)) return;
    final reminderId = payload.substring(_payloadPrefix.length);
    if (reminderId.isEmpty) return;

    final handler = _onReminderTap;
    if (handler != null) {
      handler(reminderId);
    } else {
      _pendingLaunchReminderId = reminderId;
    }
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }

  int _notificationId(String reminderId, {String suffix = ''}) =>
      '$reminderId$suffix'.hashCode.abs() % 2147483647;

  Future<void> scheduleAt({
    required String reminderId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String suffix = '',
  }) async {
    if (!_initialized) await initialize();
    if (scheduledAt.isBefore(DateTime.now())) return;

    final id = _notificationId(reminderId, suffix: suffix);
    final scheduled = tz.TZDateTime.from(scheduledAt, tz.local);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'yordambor_reminders',
          'Eslatmalar',
          channelDescription: 'Kelishuv va mijoz eslatmalari',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: '$_payloadPrefix$reminderId',
    );
  }

  Future<void> cancel(String reminderId) async {
    await cancelAllForReminder(reminderId);
  }

  Future<void> cancelAllForReminder(String reminderId) async {
    for (final suffix in [
      '',
      '_before_360',
      '_before_120',
      '_before_60',
      '_before_30',
      '_before_0',
      '_followup_1',
      '_followup_2',
      '_followup_24',
    ]) {
      await _plugin.cancel(id: _notificationId(reminderId, suffix: suffix));
    }
    for (var i = 0; i < 24; i++) {
      await _plugin.cancel(id: _notificationId(reminderId, suffix: '_x_$i'));
    }
  }
}
