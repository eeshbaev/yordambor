import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

Future<bool> showYbConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Ha',
  String cancelLabel = 'Yo\'q',
  bool isDestructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        if (isDestructive)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          )
        else
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
      ],
    ),
  );
  return result ?? false;
}
