import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';
import 'package:yordambor/presentation/shared/busy_slot_confirm.dart';

const _newClientKey = '__new_client__';

Future<void> showReminderAddSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
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
  var slotStart = DateTime.now().add(const Duration(days: 1));

  final saved = await showModalBottomSheet<bool>(
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
                value: selectedClientId,
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
                icon: Icons.schedule_outlined,
                label: formatAppointmentDateTime(slotStart),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: slotStart,
                    firstDate: DateTime.now(),
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

  if (isNewClient) {
    await service.createBookingWithNewClient(
      clientName: nameController.text.trim(),
      note: note.isEmpty ? null : note,
      slotStart: slotStart,
      xizmatName: xizmatName.isEmpty ? null : xizmatName,
    );
  } else {
    await service.createBooking(
      clientId: selectedClientId,
      slotStart: slotStart,
      xizmatName: xizmatName.isEmpty ? null : xizmatName,
      note: note.isEmpty ? null : note,
    );
  }
  invalidateProviderTools(ref);
}
