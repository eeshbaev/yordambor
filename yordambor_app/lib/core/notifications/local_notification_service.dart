import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

typedef ReminderNotificationTapHandler = void Function(String reminderId);
typedef AppNotificationTapHandler = void Function(Map<String, String> payload);

class LocalNotificationService {
  LocalNotificationService._();

  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  ReminderNotificationTapHandler? _onReminderTap;
  AppNotificationTapHandler? _onAppNotificationTap;
  String? _pendingLaunchReminderId;
  Map<String, String>? _pendingAppPayload;

  ReminderNotificationTapHandler? get onReminderTap => _onReminderTap;

  set onReminderTap(ReminderNotificationTapHandler? handler) {
    _onReminderTap = handler;
    if (handler != null && _pendingLaunchReminderId != null) {
      final id = _pendingLaunchReminderId!;
      _pendingLaunchReminderId = null;
      handler(id);
    }
  }

  set onAppNotificationTap(AppNotificationTapHandler? handler) {
    _onAppNotificationTap = handler;
    if (handler != null && _pendingAppPayload != null) {
      final payload = _pendingAppPayload!;
      _pendingAppPayload = null;
      handler(payload);
    }
  }

  static const _payloadPrefix = 'reminder:';
  static const _appPayloadPrefix = 'app:';

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
    if (payload == null) return;

    if (payload.startsWith(_appPayloadPrefix)) {
      final parts = payload.substring(_appPayloadPrefix.length).split('|');
      if (parts.length < 2) return;
      final data = <String, String>{
        'type': parts[0],
        for (var i = 1; i + 1 < parts.length; i += 2) parts[i]: parts[i + 1],
      };
      final handler = _onAppNotificationTap;
      if (handler != null) {
        handler(data);
      } else {
        _pendingAppPayload = data;
      }
      return;
    }

    if (!payload.startsWith(_payloadPrefix)) return;
    final reminderId = payload.substring(_payloadPrefix.length);
    if (reminderId.isEmpty) return;

    final handler = _onReminderTap;
    if (handler != null) {
      handler(reminderId);
    } else {
      _pendingLaunchReminderId = reminderId;
    }
  }

  String buildAppPayload({
    required String type,
    String? xizmatId,
    String? postId,
    String? kelishuvId,
  }) {
    final parts = <String>[type];
    if (xizmatId != null) {
      parts.addAll(['xizmat_id', xizmatId]);
    }
    if (postId != null) {
      parts.addAll(['post_id', postId]);
    }
    if (kelishuvId != null) {
      parts.addAll(['kelishuv_id', kelishuvId]);
    }
    return '$_appPayloadPrefix${parts.join('|')}';
  }

  Future<void> showInstant({
    required String notificationId,
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!_initialized) await initialize();

    final id = notificationId.hashCode.abs() % 2147483647;
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'yordambor_alerts',
          'Bildirishnomalar',
          channelDescription: 'Kelishuv va subsoha bildirishnomalari',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
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
