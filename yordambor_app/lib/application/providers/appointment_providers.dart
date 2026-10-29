import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/public_profile_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

/// Where an appointment stands, as its card says it.
enum AppointmentPhase {
  /// Later today.
  today,

  /// Going on now.
  now,

  /// On a later day.
  planned,

  /// Its time has passed; the deal waits to be marked done.
  past,
  done,
  cancelled,
}

/// One appointment as the person sees it: with the client when they give
/// the service, with the service when they get it.
class CalendarAppointment {
  const CalendarAppointment({
    required this.deal,
    required this.viewerId,
    required this.startsAt,
    required this.hasTime,
    required this.durationMinutes,
  });

  factory CalendarAppointment.of(Kelishuv deal, String viewerId) {
    final start = deal.startDate!;
    return CalendarAppointment(
      deal: deal,
      viewerId: viewerId,
      startsAt: deal.startHasTime
          ? start
          : DateTime(start.year, start.month, start.day),
      hasTime: deal.startHasTime,
      durationMinutes:
          (deal.durationMinutes ?? 0) > 0 ? deal.durationMinutes! : 60,
    );
  }

  final Kelishuv deal;
  final String viewerId;
  final DateTime startsAt;

  /// A time of day was agreed, not only the day.
  final bool hasTime;
  final int durationMinutes;

  String get id => deal.id;
  DateTime get day => DateTime(startsAt.year, startsAt.month, startsAt.day);
  DateTime get endsAt => startsAt.add(Duration(minutes: durationMinutes));

  /// The viewer does the job (else they get it done).
  bool get iProvide => deal.isProvider(viewerId);

  String get serviceName =>
      deal.xizmatName ?? deal.postTitle ?? '';

  String get otherPartyId => deal.otherPartyIdFor(viewerId);
  String get otherPartyName => deal.otherPartyNameFor(viewerId);
  String? get otherPartyAvatar => deal.otherPartyAvatarFor(viewerId);

  /// The phone the other side sent with the deal, if it was theirs.
  String? get dealPhone => deal.otherPartyContactFor(viewerId)?.phone;

  bool get isCancelled => deal.status == KelishuvStatus.bekor;
  bool get isDone => deal.status == KelishuvStatus.bajarildi;
  bool get isActive => deal.status == KelishuvStatus.jarayonda;

  /// The time range it takes, for busy hours.
  TimeRange? get range {
    if (!hasTime) return null;
    final start = startsAt.hour * 60 + startsAt.minute;
    final end = (start + durationMinutes).clamp(start + 1, 24 * 60);
    return TimeRange(start, end);
  }

  AppointmentPhase phaseAt(DateTime now) {
    if (isCancelled) return AppointmentPhase.cancelled;
    if (isDone) return AppointmentPhase.done;
    final today = DateTime(now.year, now.month, now.day);
    if (day.isAfter(today)) return AppointmentPhase.planned;
    if (day.isBefore(today)) return AppointmentPhase.past;
    if (!hasTime) return AppointmentPhase.today;
    if (now.isBefore(startsAt)) return AppointmentPhase.today;
    if (now.isBefore(endsAt)) return AppointmentPhase.now;
    return AppointmentPhase.past;
  }
}

/// The person's appointments from their deals: agreed, done and cancelled
/// ones with a day set, from a week ago on. Their reminders are kept in
/// step on the way.
final myAppointmentsProvider =
    FutureProvider<List<CalendarAppointment>>((ref) async {
  final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  final deals =
      await ref.watch(kelishuvRepositoryProvider).fetchAppointments(userId);
  final appointments = [
    for (final deal in deals) CalendarAppointment.of(deal, userId),
  ];
  unawaited(_keepRemindersInStep(ref, deals, userId));
  return appointments;
});

/// What the reminders were last made from; the same deals again need no
/// new reminders.
String? _syncedSignature;

Future<void> _keepRemindersInStep(
  Ref ref,
  List<Kelishuv> deals,
  String userId,
) async {
  final signature = [
    userId,
    for (final deal in deals)
      '${deal.id}:${deal.status.name}:${deal.startDate?.toIso8601String()}:'
          '${deal.startHasTime}',
  ].join('|');
  if (signature == _syncedSignature) return;
  _syncedSignature = signature;
  try {
    await ref.read(providerToolsServiceProvider).syncAppointments(
          deals,
          userId,
        );
    ref.invalidate(remindersProvider);
    ref.invalidate(bookingsProvider);
  } catch (_) {
    _syncedSignature = null;
  }
}

/// Appointments by day.
final appointmentsByDayProvider =
    Provider<Map<DateTime, List<CalendarAppointment>>>((ref) {
  final items =
      ref.watch(myAppointmentsProvider).valueOrNull ?? const <CalendarAppointment>[];
  final byDay = <DateTime, List<CalendarAppointment>>{};
  for (final item in items) {
    byDay.putIfAbsent(item.day, () => []).add(item);
  }
  for (final list in byDay.values) {
    list.sort((a, b) => a.startsAt.compareTo(b.startsAt));
  }
  return byDay;
});

/// Agreed appointments in the next day, soonest first.
final soonAppointmentsProvider = Provider<List<CalendarAppointment>>((ref) {
  final items =
      ref.watch(myAppointmentsProvider).valueOrNull ?? const <CalendarAppointment>[];
  final now = DateTime.now();
  final until = now.add(const Duration(hours: 24));
  return items
      .where(
        (item) =>
            item.isActive &&
            item.endsAt.isAfter(now) &&
            item.startsAt.isBefore(until),
      )
      .toList()
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
});

/// YordamBor accounts the provider keeps in their client book.
final savedClientAccountsProvider = Provider<Set<String>>((ref) {
  final clients = ref.watch(clientRegistryProvider).valueOrNull ?? const [];
  return {
    for (final client in clients)
      if (!client.isDeleted && client.yordamBorUserId != null)
        client.yordamBorUserId!,
  };
});

/// A phone its owner lets everyone see, else null.
final publicPhoneProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, userId) {
  return ref.watch(publicProfileRepositoryProvider).fetchPublicPhone(userId);
});

/// The phone shown on a service: the one on the listing or its owner's,
/// when they chose to show it.
final xizmatPublicPhoneProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, xizmatId) {
  return ref
      .watch(publicProfileRepositoryProvider)
      .fetchServicePublicPhone(xizmatId);
});

/// The hours a service's provider is busy with appointments, for the next
/// two weeks, when they chose to show them.
final xizmatBusyHoursProvider = FutureProvider.autoDispose
    .family<Map<DateTime, List<TimeRange>>, String>((ref, xizmatId) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(xizmatRepositoryProvider).fetchBusyHours(
        xizmatId: xizmatId,
        from: today,
        to: today.add(const Duration(days: 13)),
      );
});

/// Deals the provider was already asked about saving the client for.
abstract final class ClientSavePrompts {
  static const _boxName = 'deal_prompts';

  static Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box<dynamic>(_boxName);
    return Hive.openBox<dynamic>(_boxName);
  }

  static Future<bool> wasAsked(String dealId) async {
    try {
      return (await _box()).containsKey('save_client_$dealId');
    } catch (_) {
      return true;
    }
  }

  static Future<void> markAsked(String dealId) async {
    try {
      await (await _box()).put('save_client_$dealId', true);
    } catch (_) {
      // Asked again next time; nothing else is lost.
    }
  }
}
