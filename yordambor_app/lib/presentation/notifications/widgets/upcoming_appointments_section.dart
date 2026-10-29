import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

/// Agreed appointments of the coming week, soonest first, at the top of
/// notifications: what is next, with whom and when. Each opens its deal.
class UpcomingAppointmentsSection extends ConsumerWidget {
  const UpcomingAppointmentsSection({super.key});

  /// How far ahead appointments are shown.
  static const window = Duration(days: 7);

  /// At most this many rows.
  static const limit = 5;

  /// The appointments the section shows.
  static List<CalendarAppointment> upcoming(WidgetRef ref) {
    final items = ref.watch(myAppointmentsProvider).valueOrNull ??
        const <CalendarAppointment>[];
    final now = DateTime.now();
    final until = now.add(window);
    final list = items
        .where(
          (item) =>
              item.isActive &&
              item.endsAt.isAfter(now) &&
              item.startsAt.isBefore(until),
        )
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return list.take(limit).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = upcoming(ref);
    if (items.isEmpty) return const SizedBox.shrink();
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Semantics(
            header: true,
            child: Text(
              strings.notificationsAppointmentsTitle,
              style: AppTypography.headline.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
        for (final item in items)
          _AppointmentRow(item: item, strings: strings),
      ],
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.item, required this.strings});

  final CalendarAppointment item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final locale = strings.languageCode;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = item.day == today;
    final started = !item.startsAt.isAfter(now);
    final dayText = isToday
        ? strings.appointmentPhaseToday
        : DateFormat.MMMEd(locale).format(item.startsAt);
    final when = item.hasTime
        ? '$dayText, ${DateFormat.Hm(locale).format(item.startsAt)}'
        : dayText;
    final (phase, tone) = started
        ? (strings.appointmentPhaseNow, YbStatusTone.success)
        : isToday
            ? (strings.appointmentPhaseToday, YbStatusTone.warning)
            : (strings.appointmentPhasePlanned, YbStatusTone.primary);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      onTap: () => context.push('/kelishuv/${item.id}'),
      leading: CircleAvatar(
        backgroundColor: colors.tealSoft,
        child: Icon(YbIcons.eventAvailableFilled, color: colors.teal, size: 20),
      ),
      title: Text(
        item.serviceName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.body.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '$when · ${item.otherPartyName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.caption.copyWith(color: colors.textSecondary),
      ),
      trailing: YbStatusBadge(label: phase, tone: tone),
    );
  }
}
