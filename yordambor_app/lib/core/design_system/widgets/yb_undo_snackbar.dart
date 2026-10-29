import 'package:flutter/material.dart';

/// Says what just happened and offers to take it back, for six seconds
/// (manual S-04). Used instead of an "Are you sure?" dialog for anything
/// that can be undone. Take the [messenger] before the change, since the
/// widget that made it may be gone by the time it is done.
void showYbUndoSnackBar(
  ScaffoldMessengerState messenger, {
  required String message,
  required String undoLabel,
  required VoidCallback onUndo,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(label: undoLabel, onPressed: onUndo),
      ),
    );
}
