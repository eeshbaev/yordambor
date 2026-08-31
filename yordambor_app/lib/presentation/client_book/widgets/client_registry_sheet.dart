import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';

Future<void> showClientRegistrySheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  ClientRegistryEntry? client,
}) async {
  final isEditing = client != null;
  final nameController = TextEditingController(text: client?.clientName ?? '');
  final phoneController = TextEditingController(text: client?.phone ?? '');
  final noteController = TextEditingController(text: client?.note ?? '');

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => YbSheetBody(
      title: isEditing ? strings.clientBookEditClient : strings.clientBookAdd,
      children: [
        TextField(
          controller: nameController,
          autofocus: !isEditing,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: strings.fullName),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: strings.phone),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: noteController,
          decoration: InputDecoration(labelText: strings.clientBookNoteLabel),
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.actionSave,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );

  if (saved != true) return;

  final clientName = nameController.text.trim();
  if (clientName.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.clientBookNameRequired)),
      );
    }
    return;
  }

  final phone = phoneController.text.trim();
  final note = noteController.text.trim();
  final service = ref.read(providerToolsServiceProvider);

  if (isEditing) {
    await service.updateClient(
      client.copyWith(
        clientName: clientName,
        phone: phone.isEmpty ? null : phone,
        note: note.isEmpty ? null : note,
      ),
    );
  } else {
    await service.createClient(
      clientName: clientName,
      phone: phone.isEmpty ? null : phone,
      note: note.isEmpty ? null : note,
    );
  }
  invalidateProviderTools(ref);
}
