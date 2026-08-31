import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/domain/entities/booking.dart';
import 'package:yordambor/domain/entities/client_booking_stats.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/presentation/client_book/widgets/appointment_detail_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/appointment_status_chip.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/presentation/client_book/widgets/client_booking_sheet.dart';
import 'package:yordambor/presentation/client_book/widgets/client_registry_sheet.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';

Future<void> showClientDetailSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required ClientRegistryEntry client,
}) async {
  final service = ref.read(providerToolsServiceProvider);
  final bookingsFuture = service.fetchBookingsForClient(client.id);
  final remindersFuture = ref.read(remindersRepositoryProvider).fetchAll();
  final statsFuture = service.fetchClientStats(client.id);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      final colors = context.ybColors;

      return YbSheetBody(
        title: client.clientName,
        children: [
          if (client.phone != null && client.phone!.isNotEmpty)
            Text(
              client.phone!,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
          if (client.note != null && client.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              client.note!,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FutureBuilder(
            future: Future.wait([bookingsFuture, remindersFuture, statsFuture]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final bookings = snapshot.data![0] as List<Booking>;
              final reminders = snapshot.data![1] as List<Reminder>;
              final stats = snapshot.data![2] as ClientBookingStats;
              final reminderByBooking = {
                for (final reminder in reminders)
                  if (reminder.bookingId != null) reminder.bookingId!: reminder,
              };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.clientBookBookingCount(bookings.length),
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  if (stats.total > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      strings.clientBookClientStats(
                        stats.completed,
                        stats.cancelled,
                        stats.upcoming,
                      ),
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  if (bookings.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      strings.clientBookAppointmentHistory,
                      style: AppTypography.label.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...bookings.take(5).map((booking) {
                      final reminder = reminderByBooking[booking.id];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          onTap: () {
                            Navigator.pop(context);
                            showBookingDetailSheet(
                              context: context,
                              ref: ref,
                              strings: strings,
                              booking: BookingWithClient(
                                booking: booking,
                                client: client,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formatAppointmentDateTime(booking.slotStart),
                                    style: AppTypography.caption.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                                if (reminder != null)
                                  AppointmentStatusChip(
                                    status: reminder.status,
                                    strings: strings,
                                  ),
                                Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: colors.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          if (client.yordamBorUserId != null) ...[
            YbSecondaryButton(
              label: strings.userProfileViewProfile,
              onPressed: () {
                Navigator.pop(context);
                context.push('/user/${client.yordamBorUserId}');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          YbPrimaryButton(
            label: strings.clientBookBookClient,
            onPressed: () {
              Navigator.pop(context);
              showClientBookingSheet(
                context: context,
                ref: ref,
                strings: strings,
                initialClientId: client.id,
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          YbSecondaryButton(
            label: strings.clientBookEditClient,
            onPressed: () {
              Navigator.pop(context);
              showClientRegistrySheet(
                context: context,
                ref: ref,
                strings: strings,
                client: client,
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          YbSecondaryButton(
            label: strings.actionDelete,
            onPressed: () async {
              final confirmed = await showYbConfirmDialog(
                context,
                title: strings.actionDelete,
                message: client.clientName,
                confirmLabel: strings.actionDelete,
                isDestructive: true,
              );
              if (!confirmed || !context.mounted) return;
              await service.deleteClientFromRegistry(client.id);
              invalidateProviderTools(ref);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
