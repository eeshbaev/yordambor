import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';

class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({
    super.key,
    required this.status,
    required this.strings,
  });

  final AppointmentStatus status;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final c = context.ybColors;
    final (fill, ink) = switch (status) {
      AppointmentStatus.upcoming => (c.tealSoft, c.tealInk),
      AppointmentStatus.completed => (c.successSoft, c.success),
      AppointmentStatus.postponed => (c.apricotSoft, c.apricotInk),
      AppointmentStatus.incomplete => (c.apricotSoft, c.apricotInk),
      AppointmentStatus.cancelled => (c.errorSoft, c.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 3,
      ),
      decoration: ShapeDecoration(
        color: fill,
        shape: const StadiumBorder(),
      ),
      child: Text(
        strings.appointmentStatusLabel(status),
        style: AppTypography.label.copyWith(color: ink),
      ),
    );
  }
}
