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

Future<void> showClientBookingSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  DateTime? initialSlotStart,
  String? initialClientId,
}) async {
  final clientsAsync = ref.read(clientRegistryProvider);
  final clients = clientsAsync.maybeWhen(
    data: (value) => value,
    orElse: () => <ClientRegistryEntry>[],
  );

  var selectedClientId = initialClientId ?? _newClientKey;
  if (selectedClientId != _newClientKey &&
      !clients.any((client) => client.id == selectedClientId)) {
    selectedClientId = clients.isEmpty ? _newClientKey : clients.first.id;
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  final serviceController = TextEditingController();
  DateTime slotStart = initialSlotStart ??
      DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        9,
      );

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
            title: strings.clientBookBookClient,
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
                  decoration: InputDecoration(labelText: strings.fullName),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: strings.phone),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(strings.clientBookDateLabel),
                subtitle: Text(formatAppointmentDate(slotStart)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: slotStart,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (picked != null) {
                    setSheetState(
                      () => slotStart = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        slotStart.hour,
                        slotStart.minute,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              YbSecondaryButton(
                icon: Icons.schedule_outlined,
                label: formatAppointmentTime(slotStart),
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(slotStart),
                  );
                  if (time == null) return;
                  setSheetState(
                    () => slotStart = DateTime(
                      slotStart.year,
                      slotStart.month,
                      slotStart.day,
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
                  labelText: strings.clientBookNoteLabel,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              YbPrimaryButton(
                label: strings.actionSave,
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

  if (isNewClient) {
    final clientName = nameController.text.trim();
    if (clientName.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.clientBookNameRequired)),
        );
      }
      return;
    }
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
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
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
