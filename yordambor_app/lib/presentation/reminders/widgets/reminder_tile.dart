import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/presentation/reminders/widgets/appointment_status_chip.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_open_helper.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';

class ReminderTile extends ConsumerWidget {
  const ReminderTile({
    super.key,
    required this.reminder,
    required this.strings,
    this.dimmed = false,
  });

  final Reminder reminder;
  final AppStrings strings;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final opacity = dimmed ? 0.55 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Dismissible(
        key: ValueKey(reminder.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          color: AppColors.error,
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          if (reminder.bookingId != null) {
            await ref
                .read(providerToolsServiceProvider)
                .deleteAppointment(reminder.bookingId!);
          } else {
            await ref
                .read(remindersRepositoryProvider)
                .deleteReminder(reminder.id);
          }
          invalidateProviderTools(ref);
          return true;
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          leading: Icon(
            reminder.isLinkedToBooking
                ? Icons.event_available_outlined
                : Icons.alarm_outlined,
            color: AppColors.primary,
          ),
          title: Text(
            reminder.title,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppointmentStatusChip(
                  status: reminder.status,
                  strings: strings,
                ),
              ),
              if (reminder.body != null && reminder.body!.isNotEmpty)
                Text(
                  reminder.body!,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              Text(
                formatAppointmentDateTime(reminder.scheduledAt),
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          onTap: () => openReminderContext(
            context: context,
            ref: ref,
            strings: strings,
            reminder: reminder,
          ),
        ),
      ),
    );
  }
}

class ReminderSectionHeader extends StatelessWidget {
  const ReminderSectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(color: colors.textTertiary),
      ),
    );
  }
}
