import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yordambor/application/growth/growth_program.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

/// A tip the person has reached in the program.
class GrowthTipView {
  const GrowthTipView({
    required this.tip,
    required this.done,
    required this.read,
  });

  final GrowthTip tip;

  /// What it asks for is already done.
  final bool done;
  final bool read;
}

/// Where the person is in their 30 days.
class GrowthProgramState {
  const GrowthProgramState({
    required this.track,
    required this.start,
    required this.day,
    required this.delivered,
    required this.services,
  });

  final GrowthTrack track;
  final DateTime start;

  /// Days since it started: 0 on the day of the first service.
  final int day;

  /// The tips reached so far, newest first.
  final List<GrowthTipView> delivered;

  /// The person's own services, for the tips' buttons.
  final List<XizmatFeedItem> services;

  int get unread => delivered.where((view) => !view.read).length;

  GrowthTipView? get latest => delivered.isEmpty ? null : delivered.first;
}

/// What the program keeps on this device: when it started for each person,
/// the tips they have seen, and whether tips are on.
abstract final class GrowthProgramStore {
  static const _boxName = 'growth_program';

  static Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box<dynamic>(_boxName);
    return Hive.openBox<dynamic>(_boxName);
  }

  static Future<bool> enabled() async {
    try {
      return (await _box()).get('enabled', defaultValue: true) as bool;
    } catch (_) {
      return true;
    }
  }

  static Future<void> setEnabled(bool value) async {
    try {
      await (await _box()).put('enabled', value);
    } catch (_) {
      // Stays as it was.
    }
  }

  static Future<DateTime?> start(String userId) async {
    try {
      final raw = (await _box()).get('start_$userId');
      return raw is String ? DateTime.tryParse(raw) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> setStart(String userId, DateTime day) async {
    try {
      await (await _box()).put('start_$userId', day.toIso8601String());
    } catch (_) {
      // Worked out again next time.
    }
  }

  static Future<Set<String>> read(String userId) async {
    try {
      final raw = (await _box()).get('read_$userId');
      return raw is List ? raw.map((id) => '$id').toSet() : <String>{};
    } catch (_) {
      return <String>{};
    }
  }

  static Future<void> markRead(String userId, Iterable<String> ids) async {
    try {
      final box = await _box();
      final current = await read(userId);
      await box.put('read_$userId', {...current, ...ids}.toList());
    } catch (_) {
      // Shown as new once more.
    }
  }
}

/// Tips on or off on this device.
final growthTipsEnabledProvider =
    StateNotifierProvider<GrowthTipsEnabledNotifier, bool>((ref) {
  return GrowthTipsEnabledNotifier();
});

class GrowthTipsEnabledNotifier extends StateNotifier<bool> {
  GrowthTipsEnabledNotifier() : super(true) {
    unawaited(_load());
  }

  Future<void> _load() async {
    final value = await GrowthProgramStore.enabled();
    if (mounted) state = value;
  }

  Future<void> set(bool value) async {
    state = value;
    await GrowthProgramStore.setEnabled(value);
  }
}

DateTime _dayOf(DateTime value) => DateTime(value.year, value.month, value.day);

/// The person's program, or null when there is none: signed out, no
/// service yet, tips off, or the month is over. Keeps the coming tips
/// scheduled as notifications.
final growthProgramProvider = FutureProvider<GrowthProgramState?>((ref) async {
  final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
  final enabled = ref.watch(growthTipsEnabledProvider);
  final strings = ref.watch(appStringsProvider);
  if (userId == null) {
    // Signed out: the last account's tips must not keep arriving.
    unawaited(_schedule(null, strings, enabled: enabled));
    return null;
  }

  final mine = await ref.watch(myXizmatlarProvider.future);
  final services = mine.where((item) => !item.isDemo).toList();
  if (!enabled || services.isEmpty) {
    unawaited(_schedule(null, strings, enabled: enabled));
    return null;
  }

  final today = _dayOf(DateTime.now());
  var start = await GrowthProgramStore.start(userId);
  if (start == null) {
    // From the first service, or from today for someone whose services
    // came before the program did.
    final dates = services
        .map((item) => item.createdAt)
        .whereType<DateTime>()
        .map((date) => _dayOf(date.toLocal()))
        .toList()
      ..sort();
    final first = dates.isEmpty ? today : dates.first;
    start = today.difference(first).inDays > GrowthProgram.days
        ? today
        : first;
    await GrowthProgramStore.setStart(userId, start);
  }

  final day = today.difference(start).inDays;
  if (day > GrowthProgram.days) {
    unawaited(_schedule(null, strings, enabled: enabled));
    return null;
  }

  final track = GrowthProgram.trackOf(services);
  final read = await GrowthProgramStore.read(userId);
  final delivered = [
    for (final tip in GrowthProgram.tipsFor(track).reversed)
      if (tip.day <= day)
        GrowthTipView(
          tip: tip,
          done: GrowthProgram.isDone(tip.action, services),
          read: read.contains(tip.id),
        ),
  ];

  final state = GrowthProgramState(
    track: track,
    start: start,
    day: day,
    delivered: delivered,
    services: services,
  );
  unawaited(_schedule(state, strings, enabled: enabled));
  return state;
});

/// New tips waiting for the bell.
final growthUnreadCountProvider = Provider<int>((ref) {
  return ref.watch(growthProgramProvider).valueOrNull?.unread ?? 0;
});

/// What the notifications were last scheduled from.
String? _scheduledSignature;

/// Sends the program's coming tips as notifications at [GrowthProgram
/// .sendHour], skipping the ones already done; with no program, none.
Future<void> _schedule(
  GrowthProgramState? state,
  AppStrings strings, {
  required bool enabled,
}) async {
  final tips = state == null
      ? const <GrowthTip>[]
      : [
          for (final tip in GrowthProgram.tipsFor(state.track))
            if (tip.day > state.day ||
                (tip.day == state.day &&
                    DateTime.now().hour < GrowthProgram.sendHour))
              if (tip.day > 0 &&
                  !GrowthProgram.isDone(tip.action, state.services))
                tip,
        ];
  final signature = [
    enabled,
    strings.languageCode,
    state?.start.toIso8601String(),
    for (final tip in tips) tip.id,
  ].join('|');
  if (signature == _scheduledSignature) return;
  _scheduledSignature = signature;

  final notifications = LocalNotificationService.instance;
  try {
    await notifications.cancelTips();
    if (state == null) return;
    for (final tip in tips) {
      final day = state.start.add(Duration(days: tip.day));
      await notifications.scheduleTip(
        key: tip.id,
        title: GrowthProgram.title(strings, tip.id),
        body: GrowthProgram.body(strings, tip.id),
        at: DateTime(day.year, day.month, day.day, GrowthProgram.sendHour),
      );
    }
  } catch (_) {
    _scheduledSignature = null;
  }
}
