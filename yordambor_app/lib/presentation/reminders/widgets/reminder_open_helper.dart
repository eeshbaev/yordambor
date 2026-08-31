import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/presentation/client_book/widgets/appointment_detail_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_sheet.dart';

Future<void> openReminderContext({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required Reminder reminder,
}) async {
  final bookingId = reminder.bookingId;
  if (bookingId != null) {
    final booking = await ref.read(bookingRepositoryProvider).fetchById(bookingId);
    if (booking != null && !booking.isReceiverSide) {
      final client =
          await ref.read(clientRegistryRepositoryProvider).fetchById(
                booking.clientId,
              );
      if (client != null && context.mounted) {
        await showBookingDetailSheet(
          context: context,
          ref: ref,
          strings: strings,
          booking: BookingWithClient(booking: booking, client: client),
        );
        return;
      }
    }
  }

  if (!context.mounted) return;
  await showReminderStatusSheet(
    context: context,
    ref: ref,
    strings: strings,
    reminder: reminder,
  );
}
