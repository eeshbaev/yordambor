import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';

Future<double?> showCompleteAmountSheet({
  required BuildContext context,
  required AppStrings strings,
  double? initialAmount,
}) async {
  final amountController = TextEditingController(
    text: initialAmount != null ? initialAmount.toStringAsFixed(0) : '',
  );

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => YbSheetBody(
      title: strings.clientBookMarkComplete,
      children: [
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: strings.clientBookCompleteAmount,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        YbPrimaryButton(
          label: strings.actionSave,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );

  if (saved != true) return null;

  final amount = double.tryParse(amountController.text.trim());
  if (amount == null || amount <= 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.earningsAmountRequired)),
      );
    }
    return null;
  }
  return amount;
}

Future<DateTime?> pickRescheduleDateTime(
  BuildContext context,
  DateTime initial,
) async {
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
  );
  if (date == null || !context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

Future<void> applyAppointmentStatus({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required String bookingId,
  required AppointmentStatus status,
  bool isReceiverSide = false,
  double? suggestedAmount,
}) async {
  final service = ref.read(providerToolsServiceProvider);

  if (status == AppointmentStatus.completed) {
    if (isReceiverSide) {
      await service.setAppointmentStatus(
        bookingId: bookingId,
        status: status,
      );
    } else {
      final amount = await showCompleteAmountSheet(
        context: context,
        strings: strings,
        initialAmount: suggestedAmount,
      );
      if (amount == null) return;
      await service.setAppointmentStatus(
        bookingId: bookingId,
        status: status,
        amount: amount,
      );
    }
  } else if (status == AppointmentStatus.postponed ||
      status == AppointmentStatus.incomplete) {
    final newSlot = await pickRescheduleDateTime(
      context,
      DateTime.now().add(const Duration(days: 1)),
    );
    if (newSlot == null) return;
    await service.setAppointmentStatus(
      bookingId: bookingId,
      status: status,
      newSlotStart: newSlot,
    );
  } else {
    await service.setAppointmentStatus(
      bookingId: bookingId,
      status: status,
    );
  }
  invalidateProviderTools(ref);
}
