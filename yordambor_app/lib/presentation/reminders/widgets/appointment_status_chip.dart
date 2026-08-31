import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
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
    final color = switch (status) {
      AppointmentStatus.upcoming => AppColors.primary,
      AppointmentStatus.completed => AppColors.primary,
      AppointmentStatus.postponed => AppColors.warning,
      AppointmentStatus.incomplete => AppColors.warning,
      AppointmentStatus.cancelled => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        strings.appointmentStatusLabel(status),
        style: AppTypography.caption.copyWith(color: color),
      ),
    );
  }
}
