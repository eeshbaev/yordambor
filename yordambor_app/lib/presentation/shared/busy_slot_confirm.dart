import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';

Future<bool> confirmBusySlotConflicts(
  BuildContext context,
  AppStrings strings,
  List<BookingWithClient> conflicts,
) {
  if (conflicts.isEmpty) return Future.value(true);

  final names = conflicts.map((entry) => entry.clientName).join(', ');
  return showYbConfirmDialog(
    context,
    title: strings.busySlotTitle,
    message: strings.busySlotMessage(names),
    confirmLabel: strings.xizmatContinue,
  );
}
