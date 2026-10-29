import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/schedule/reminder_busy_sync.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';

const _newClientKey = '__new_client__';

/// How long the reminder's time can show as busy, in minutes.
const _busyLengths = [30, 60, 120, 180];

/// The busy stretch from [start] for [minutes], within its day.
TimeRange _busyRange(DateTime start, int minutes) {
  final from = start.hour * 60 + start.minute;
  final to = (from + minutes).clamp(from + 1, 24 * 60);
  return TimeRange(from, to);
}

/// Adds a job reminder: a client (a new one is saved to the client list),
/// a time, and optionally that time shown to clients as busy. [initialStart]
/// fills the time, e.g. from the hour tapped in the day view.
Future<void> showReminderAddSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  DateTime? initialStart,
}) async {
  final clientsAsync = ref.read(clientRegistryProvider);
  final clients = clientsAsync.maybeWhen(
    data: (value) => value,
    orElse: () => <ClientRegistryEntry>[],
  );

  var selectedClientId = clients.isEmpty ? _newClientKey : clients.first.id;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final serviceController = TextEditingController();
  var slotStart =
      initialStart ?? DateTime.now().add(const Duration(days: 1));
  // Off by default: the person chooses to show the time as busy.
  var showBusy = false;
  var busyMinutes = 60;

  final saved = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final isNewClient = selectedClientId == _newClientKey;

          return YbSheetBody(
            title: strings.remindersAdd,
            children: [
              DropdownButtonFormField<String>(
                icon: const Icon(YbIcons.expandMore),
                initialValue: selectedClientId,
                decoration: InputDecoration(
                  labelText: strings.clientBookSelectClient,
                ),
                items: [
                  ...clients.map(
                    (client) => DropdownMenuItem(
                      value: client.id,
                      child: Text(client.clientName),
                    ),
                  ),
                  DropdownMenuItem(
                    value: _newClientKey,
                    child: Text(strings.clientBookNewClientOption),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setSheetState(() => selectedClientId = value);
                },
              ),
              if (isNewClient) ...[
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: strings.remindersFieldClientName,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              YbSecondaryButton(
                icon: YbIcons.schedule,
                label: formatAppointmentDateTime(slotStart),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: slotStart,
                    firstDate: slotStart.isBefore(DateTime.now())
                        ? slotStart
                        : DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null || !context.mounted) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(slotStart),
                  );
                  if (time == null) return;
                  setSheetState(
                    () => slotStart = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: serviceController,
                decoration: InputDecoration(
                  labelText: strings.clientBookServiceLabel,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: strings.remindersFieldBody,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: showBusy,
                onChanged: (value) => setSheetState(() => showBusy = value),
                title: Text(strings.remindersShowBusy),
                subtitle: Text(
                  strings.remindersShowBusyHint,
                  style: AppTypography.caption.copyWith(
                    color: context.ybColors.textSecondary,
                  ),
                ),
              ),
              AnimatedSize(
                duration: AppMotion.of(context, AppMotion.standardDuration),
                curve: AppMotion.standard,
                alignment: Alignment.topCenter,
                child: !showBusy
                    ? const SizedBox(width: double.infinity)
                    : Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final minutes in _busyLengths)
                            ChoiceChip(
                              label: Text(
                                _busyRange(slotStart, minutes).label,
                                style: AppTypography.tabular(
                                  AppTypography.label,
                                ),
                              ),
                              selected: busyMinutes == minutes,
                              onSelected: (_) => setSheetState(
                                () => busyMinutes = minutes,
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              YbPrimaryButton(
                label: strings.remindersSave,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        },
      );
    },
  );

  if (saved != true) return;

  final service = ref.read(providerToolsServiceProvider);
  final xizmatName = serviceController.text.trim();
  final note = noteController.text.trim();
  final isNewClient = selectedClientId == _newClientKey;

  if (isNewClient && nameController.text.trim().isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.clientBookNameRequired)),
      );
    }
    return;
  }

  final conflicts = await service.findSlotConflicts(slotStart: slotStart);
  if (conflicts.isNotEmpty && context.mounted) {
    final proceed = await confirmBusySlotConflicts(
      context,
      strings,
      conflicts,
    );
    if (!proceed) return;
  }

  final created = isNewClient
      ? await service.createBookingWithNewClient(
          clientName: nameController.text.trim(),
          note: note.isEmpty ? null : note,
          slotStart: slotStart,
          xizmatName: xizmatName.isEmpty ? null : xizmatName,
        )
      : await service.createBooking(
          clientId: selectedClientId,
          slotStart: slotStart,
          xizmatName: xizmatName.isEmpty ? null : xizmatName,
          note: note.isEmpty ? null : note,
        );
  // The busy time follows the reminder from now on: cancelled, completed
  // or deleted frees it, moved moves it.
  if (showBusy) {
    await ref
        .read(reminderBusySyncServiceProvider)
        .register(created.booking.id, busyMinutes);
  }
  invalidateProviderTools(ref);
}
