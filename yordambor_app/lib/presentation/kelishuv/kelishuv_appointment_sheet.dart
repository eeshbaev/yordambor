import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_actions.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';

Future<bool> showKelishuvAppointmentSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required Kelishuv kelishuv,
  required String userId,
}) async {
  DateTime selected = DateTime.now().add(const Duration(days: 1));

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return YbSheetBody(
            title: strings.kelishuvAppointmentRequiredTitle,
            children: [
              Text(
                strings.kelishuvAppointmentRequiredBody,
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.md),
              YbSecondaryButton(
                icon: Icons.schedule_outlined,
                label: formatAppointmentDateTime(selected),
                onPressed: () async {
                  final picked = await pickRescheduleDateTime(context, selected);
                  if (picked != null) {
                    setSheetState(() => selected = picked);
                  }
                },
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

  if (saved != true) return false;

  await ref.read(providerToolsServiceProvider).setKelishuvAppointment(
        kelishuv: kelishuv,
        userId: userId,
        slotStart: selected,
      );
  invalidateProviderTools(ref);
  return true;
}
