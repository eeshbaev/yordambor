import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/booking.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

class RemindersRepository {
  RemindersRepository(this._notifications);

  static const boxName = 'reminders';
  static const settingsKey = 'reminder_settings';

  final LocalNotificationService _notifications;

  Future<Box<Map>> _box() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Map>(boxName);
    }
    return Hive.openBox<Map>(boxName);
  }

  Future<ReminderSettings> fetchSettings() async {
    final box = await _box();
    final raw = box.get(settingsKey);
    if (raw == null) return const ReminderSettings();
    return ReminderSettings.fromMap(Map<dynamic, dynamic>.from(raw));
  }

  Future<void> saveSettings(ReminderSettings settings) async {
    final box = await _box();
    await box.put(settingsKey, settings.toMap());
  }

  Future<List<Reminder>> fetchAll() async {
    final box = await _box();
    return box.values
        .map((raw) {
          final map = Map<dynamic, dynamic>.from(raw);
          if (map['id'] == settingsKey) return null;
          return Reminder.fromMap(map);
        })
        .whereType<Reminder>()
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  Future<Reminder?> fetchByBookingId(String bookingId) async {
    final all = await fetchAll();
    for (final reminder in all) {
      if (reminder.bookingId == bookingId) return reminder;
    }
    return null;
  }

  Future<Reminder?> fetchById(String id) async {
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    final map = Map<dynamic, dynamic>.from(raw);
    if (map['id'] == settingsKey) return null;
    return Reminder.fromMap(map);
  }

  Future<void> syncForBooking({
    required Booking booking,
    required ClientRegistryEntry client,
    AppointmentStatus status = AppointmentStatus.upcoming,
  }) async {
    if (booking.isReceiverSide) {
      await _upsertReminder(
        booking: booking,
        client: client,
        status: status,
        kelishuvId: booking.kelishuvId,
      );
      return;
    }

    await _upsertReminder(
      booking: booking,
      client: client,
      status: status,
      kelishuvId: booking.kelishuvId,
    );
  }

  Future<void> _upsertReminder({
    required Booking booking,
    required ClientRegistryEntry client,
    required AppointmentStatus status,
    String? kelishuvId,
  }) async {
    final settings = await fetchSettings();
    final title = booking.xizmatName ?? client.clientName;
    final body = booking.note ?? '${client.clientName} bilan uchrashuv';

    final existing = await fetchByBookingId(booking.id);
    final reminder = (existing ??
            Reminder(
              id: const Uuid().v4(),
              title: title,
              scheduledAt: booking.slotStart,
              status: status,
              createdAt: DateTime.now(),
            ))
        .copyWith(
      title: title,
      body: body,
      scheduledAt: booking.slotStart,
      status: status,
      bookingId: booking.id,
      clientId: client.id,
    );

    final box = await _box();
    await box.put(reminder.id, reminder.toMap());
    await _rescheduleNotifications(reminder, settings);
  }

  Future<void> updateStatus({
    required String bookingId,
    required AppointmentStatus status,
    DateTime? newSlotStart,
  }) async {
    final reminder = await fetchByBookingId(bookingId);
    if (reminder == null) return;

    final updated = reminder.copyWith(
      status: status,
      scheduledAt: newSlotStart ?? reminder.scheduledAt,
    );
    final box = await _box();
    await box.put(updated.id, updated.toMap());

    final settings = await fetchSettings();
    if (status == AppointmentStatus.cancelled ||
        status == AppointmentStatus.completed) {
      await _notifications.cancelAllForReminder(updated.id);
    } else {
      await _rescheduleNotifications(updated, settings);
    }
  }

  Future<List<Reminder>> fetchUpcoming() async {
    final all = await fetchAll();
    final now = DateTime.now();
    return all
        .where((r) => r.scheduledAt.isAfter(now) && r.status.isActive)
        .toList();
  }

  Future<void> deleteByBookingId(String bookingId) async {
    final reminder = await fetchByBookingId(bookingId);
    if (reminder == null) return;
    await deleteReminder(reminder.id);
  }

  Future<String?> deleteReminder(String id) async {
    final box = await _box();
    final raw = box.get(id);
    String? bookingId;
    if (raw != null) {
      bookingId = Map<dynamic, dynamic>.from(raw)['bookingId'] as String?;
    }
    await box.delete(id);
    await _notifications.cancelAllForReminder(id);
    return bookingId;
  }

  Future<void> _rescheduleNotifications(
    Reminder reminder,
    ReminderSettings settings,
  ) async {
    await _notifications.cancelAllForReminder(reminder.id);
    if (!reminder.status.isActive) return;

    for (final minutesBefore in settings.alertMinutesBefore) {
      final fireAt = reminder.scheduledAt.subtract(Duration(minutes: minutesBefore));
      if (fireAt.isBefore(DateTime.now())) continue;
      await _notifications.scheduleAt(
        reminderId: reminder.id,
        suffix: '_before_$minutesBefore',
        title: reminder.title,
        body: minutesBefore == 0
            ? reminder.body ?? reminder.title
            : '${reminder.body ?? reminder.title} (${_formatLead(minutesBefore)})',
        scheduledAt: fireAt,
      );
    }

    for (final hoursAfter in settings.followUpHoursAfter) {
      final fireAt = reminder.scheduledAt.add(Duration(hours: hoursAfter));
      if (fireAt.isBefore(DateTime.now())) continue;
      await _notifications.scheduleAt(
        reminderId: reminder.id,
        suffix: '_followup_$hoursAfter',
        title: reminder.title,
        body: '${reminder.body ?? reminder.title} — ${_followUpBody(hoursAfter)}',
        scheduledAt: fireAt,
      );
    }
  }

  String _followUpBody(int hoursAfter) {
    if (hoursAfter >= 24) return 'Uchrashuv yakunlandimi?';
    return 'Xizmat bajarildimi?';
  }

  Future<List<Reminder>> fetchNeedingFollowUp() async {
    final settings = await fetchSettings();
    final all = await fetchAll();
    final now = DateTime.now();

    return all.where((reminder) {
      if (reminder.status != AppointmentStatus.upcoming) return false;
      if (reminder.scheduledAt.isAfter(now)) return false;
      final hoursSince =
          now.difference(reminder.scheduledAt).inMinutes / 60.0;
      return settings.followUpHoursAfter.any(
        (hours) => hoursSince >= hours,
      );
    }).toList();
  }

  String _formatLead(int minutes) {
    if (minutes >= 60) return '${minutes ~/ 60} soat oldin';
    return '$minutes daqiqa oldin';
  }
}
