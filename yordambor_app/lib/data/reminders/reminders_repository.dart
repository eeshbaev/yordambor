import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/booking.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

class RemindersRepository {
  RemindersRepository(this._notifications, {this.languageOf});

  static const boxName = 'reminders';
  static const settingsKey = 'reminder_settings';

  final LocalNotificationService _notifications;
  /// Reads the app language; null means Uzbek.
  final String Function()? languageOf;

  /// The app language (uz, ru, en or zh), which reminder texts are written
  /// in when they are scheduled.
  String get language => languageOf?.call() ?? 'uz';

  AppStrings get _strings => AppStrings.forLanguage(language);

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

  /// Saves [settings] and schedules every active reminder's alerts again
  /// by them.
  Future<void> saveSettings(ReminderSettings settings) async {
    final box = await _box();
    await box.put(settingsKey, settings.toMap());
    await rescheduleAll(settings);
  }

  /// Schedules the alerts of every active reminder again: after the
  /// settings or the language change.
  Future<void> rescheduleAll([ReminderSettings? settings]) async {
    final current = settings ?? await fetchSettings();
    for (final reminder in await fetchAll()) {
      await _rescheduleNotifications(reminder, current);
    }
  }

  /// Every reminder, soonest first. The settings live in the same box
  /// under [settingsKey] (with no `id` field), so entries are told apart by
  /// their key; one that cannot be read is skipped, not fatal.
  Future<List<Reminder>> fetchAll() async {
    final box = await _box();
    final reminders = <Reminder>[];
    for (final key in box.keys) {
      if (key == settingsKey) continue;
      final raw = box.get(key);
      if (raw == null) continue;
      try {
        reminders.add(Reminder.fromMap(Map<dynamic, dynamic>.from(raw)));
      } catch (_) {
        // A damaged entry; the rest still show.
      }
    }
    return reminders..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  Future<Reminder?> fetchByBookingId(String bookingId) async {
    final all = await fetchAll();
    for (final reminder in all) {
      if (reminder.bookingId == bookingId) return reminder;
    }
    return null;
  }

  Future<Reminder?> fetchById(String id) async {
    if (id == settingsKey) return null;
    final box = await _box();
    final raw = box.get(id);
    if (raw == null) return null;
    try {
      return Reminder.fromMap(Map<dynamic, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
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
    final body = booking.note ?? _strings.reminderDefaultBody(client.clientName);

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
            : '${reminder.body ?? reminder.title} '
                '(${_strings.reminderLead(minutesBefore).toLowerCase()})',
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

  String _followUpBody(int hoursAfter) => hoursAfter >= 24
      ? _strings.remindersFollowUpPrompt
      : _strings.reminderFollowUpServiceDone;

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
}
