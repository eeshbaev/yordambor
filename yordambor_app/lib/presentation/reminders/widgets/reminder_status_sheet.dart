import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_actions.dart';

Future<void> showReminderStatusSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required Reminder reminder,
}) async {
  if (reminder.bookingId == null) return;

  final bookingId = reminder.bookingId!;
  final booking = await ref.read(bookingRepositoryProvider).fetchById(bookingId);
  final isReceiverSide = booking?.isReceiverSide ?? false;

  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      final colors = context.ybColors;

      return YbSheetBody(
        title: reminder.title,
        children: [
          Text(
            reminder.body ?? '',
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (reminder.status != AppointmentStatus.completed)
            YbPrimaryButton(
              label: strings.clientBookMarkComplete,
              onPressed: () async {
                Navigator.pop(context);
                await applyAppointmentStatus(
                  context: context,
                  ref: ref,
                  strings: strings,
                  bookingId: bookingId,
                  status: AppointmentStatus.completed,
                  isReceiverSide: isReceiverSide,
                );
              },
            ),
          if (reminder.status != AppointmentStatus.incomplete) ...[
            const SizedBox(height: AppSpacing.sm),
            YbSecondaryButton(
              label: strings.appointmentStatusIncomplete,
              onPressed: () async {
                Navigator.pop(context);
                await applyAppointmentStatus(
                  context: context,
                  ref: ref,
                  strings: strings,
                  bookingId: bookingId,
                  status: AppointmentStatus.incomplete,
                );
              },
            ),
          ],
          if (reminder.status != AppointmentStatus.cancelled) ...[
            const SizedBox(height: AppSpacing.sm),
            YbSecondaryButton(
              label: strings.clientBookMarkCancelled,
              onPressed: () async {
                Navigator.pop(context);
                await applyAppointmentStatus(
                  context: context,
                  ref: ref,
                  strings: strings,
                  bookingId: bookingId,
                  status: AppointmentStatus.cancelled,
                );
              },
            ),
          ],
          if (reminder.status != AppointmentStatus.postponed) ...[
            const SizedBox(height: AppSpacing.sm),
            YbSecondaryButton(
              label: strings.appointmentStatusPostponed,
              onPressed: () async {
                Navigator.pop(context);
                await applyAppointmentStatus(
                  context: context,
                  ref: ref,
                  strings: strings,
                  bookingId: bookingId,
                  status: AppointmentStatus.postponed,
                );
              },
            ),
          ],
        ],
      );
    },
  );
}
