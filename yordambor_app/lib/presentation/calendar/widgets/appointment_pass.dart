import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_scale_tap.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';

// ── Compact card ──────────────────────────────────────────────────────────────

/// A compact single-row appointment card.
/// Tap to open the full [AppointmentDetailSheet].
class AppointmentPass extends ConsumerWidget {
  const AppointmentPass({
    super.key,
    required this.appt,
    required this.strings,
    required this.onCancel,
    required this.onSaveClient,
  });

  final CalendarAppointment appt;
  final AppStrings strings;
  final VoidCallback onCancel;
  final VoidCallback? onSaveClient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final locale = ref.watch(appStringsProvider).languageCode;
    final phase = appt.phaseAt(DateTime.now());
    final isDimmed = appt.isCancelled || appt.isDone;
    final bandColor = appt.iProvide ? colors.teal : colors.apricot;

    final (phaseLabel, phaseTone) = switch (phase) {
      AppointmentPhase.now => (strings.appointmentPhaseNow, YbStatusTone.success),
      AppointmentPhase.today => (strings.appointmentPhaseToday, YbStatusTone.primary),
      AppointmentPhase.planned => (strings.appointmentPhasePlanned, YbStatusTone.neutral),
      AppointmentPhase.past => (strings.appointmentPhasePast, YbStatusTone.warning),
      AppointmentPhase.done => (strings.appointmentPhaseDone, YbStatusTone.success),
      AppointmentPhase.cancelled => (strings.appointmentPhaseCancelled, YbStatusTone.neutral),
    };

    final timeFmt = DateFormat.Hm(locale);
    final timeStr = appt.hasTime
        ? '${timeFmt.format(appt.startsAt)} – ${timeFmt.format(appt.endsAt)}'
        : DateFormat.MMMd(locale).format(appt.startsAt);

    final roleLabel = appt.iProvide
        ? strings.appointmentRoleProvider
        : strings.appointmentRoleClient;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Opacity(
        opacity: isDimmed ? 0.6 : 1.0,
        child: YbScaleTap(
          onTap: () => showAppointmentDetailSheet(
            context: context,
            appt: appt,
            strings: strings,
            onCancel: onCancel,
            onSaveClient: onSaveClient,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: bandColor.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent bar showing provider/client role.
                    Container(width: 4, color: bandColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm + 2,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    timeStr,
                                    style: AppTypography.label.copyWith(
                                      color: colors.ink,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${appt.serviceName} · $roleLabel',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.caption.copyWith(
                                      color: colors.ink3,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    appt.otherPartyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.body.copyWith(
                                      color: colors.ink2,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            YbStatusBadge(label: phaseLabel, tone: phaseTone),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Detail sheet ──────────────────────────────────────────────────────────────

/// Opens the full appointment ticket as a bottom sheet.
Future<void> showAppointmentDetailSheet({
  required BuildContext context,
  required CalendarAppointment appt,
  required AppStrings strings,
  required VoidCallback onCancel,
  required VoidCallback? onSaveClient,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    sheetAnimationStyle: AppMotion.sheetOf(context),
    builder: (_) => AppointmentDetailSheet(
      appt: appt,
      strings: strings,
      onCancel: onCancel,
      onSaveClient: onSaveClient,
    ),
  );
}

/// Full ticket-style appointment detail. Used inside a bottom sheet.
class AppointmentDetailSheet extends ConsumerStatefulWidget {
  const AppointmentDetailSheet({
    super.key,
    required this.appt,
    required this.strings,
    required this.onCancel,
    required this.onSaveClient,
  });

  final CalendarAppointment appt;
  final AppStrings strings;
  final VoidCallback onCancel;
  final VoidCallback? onSaveClient;

  @override
  ConsumerState<AppointmentDetailSheet> createState() =>
      _AppointmentDetailSheetState();
}

class _AppointmentDetailSheetState
    extends ConsumerState<AppointmentDetailSheet> {
  Future<void> _call(String phone) async {
    await launchUrl(Uri(scheme: 'tel', path: phone));
  }

  Future<void> _confirmCancel() async {
    final strings = widget.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.appointmentCancelTitle),
        content: Text(strings.appointmentCancelBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(strings.actionKeep),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.ybColors.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(strings.appointmentCancelConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
      widget.onCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appt;
    final strings = widget.strings;
    final colors = context.ybColors;
    final locale = ref.watch(appStringsProvider).languageCode;
    final phase = appt.phaseAt(DateTime.now());
    final isActive = appt.isActive;

    final bandColor = appt.iProvide ? colors.teal : colors.apricot;
    final bandColorInk = appt.iProvide ? colors.tealInk : colors.apricotInk;
    final bandSoft = appt.iProvide ? colors.tealSoft : colors.apricotSoft;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: _PassCard(
        appt: appt,
        strings: strings,
        phase: phase,
        bandColor: bandColor,
        bandColorInk: bandColorInk,
        bandSoft: bandSoft,
        locale: locale,
        colors: colors,
        isActive: isActive,
        onCall: appt.dealPhone != null
            ? () => _call(appt.dealPhone!)
            : () => ref
                .read(publicPhoneProvider(appt.otherPartyId).future)
                .then((phone) => phone != null ? _call(phone) : null),
        onViewDeal: () {
          Navigator.of(context).pop();
          context.push('/kelishuv/${appt.id}');
        },
        onConfirmCancel: isActive ? _confirmCancel : null,
        onSaveClient: widget.onSaveClient,
      ),
    );
  }
}

// ── Pass card (full ticket visual) ───────────────────────────────────────────

class _PassCard extends StatelessWidget {
  const _PassCard({
    required this.appt,
    required this.strings,
    required this.phase,
    required this.bandColor,
    required this.bandColorInk,
    required this.bandSoft,
    required this.locale,
    required this.colors,
    required this.isActive,
    required this.onCall,
    required this.onViewDeal,
    required this.onConfirmCancel,
    required this.onSaveClient,
  });

  final CalendarAppointment appt;
  final AppStrings strings;
  final AppointmentPhase phase;
  final Color bandColor;
  final Color bandColorInk;
  final Color bandSoft;
  final String locale;
  final YbThemeColors colors;
  final bool isActive;
  final VoidCallback onCall;
  final VoidCallback onViewDeal;
  final VoidCallback? onConfirmCancel;
  final VoidCallback? onSaveClient;

  @override
  Widget build(BuildContext context) {
    final deal = appt.deal;
    final categoryIcon = CategoryIcons.forService(
      categoryId: deal.serviceCategoryId,
      subcategoryId: deal.serviceSubcategoryId,
    );

    final (phaseLabel, phaseTone) = switch (phase) {
      AppointmentPhase.now => (strings.appointmentPhaseNow, YbStatusTone.success),
      AppointmentPhase.today => (strings.appointmentPhaseToday, YbStatusTone.primary),
      AppointmentPhase.planned => (strings.appointmentPhasePlanned, YbStatusTone.neutral),
      AppointmentPhase.past => (strings.appointmentPhasePast, YbStatusTone.warning),
      AppointmentPhase.done => (strings.appointmentPhaseDone, YbStatusTone.success),
      AppointmentPhase.cancelled => (strings.appointmentPhaseCancelled, YbStatusTone.neutral),
    };

    final timeFmt = DateFormat.Hm(locale);
    final timeStr = appt.hasTime
        ? '${timeFmt.format(appt.startsAt)} – ${timeFmt.format(appt.endsAt)}'
        : DateFormat.yMMMMd(locale).format(appt.startsAt);

    final roleLabel =
        appt.iProvide ? strings.appointmentRoleProvider : strings.appointmentRoleClient;
    final otherLabel =
        appt.iProvide ? strings.appointmentPartyClient : strings.appointmentPartyProvider;

    final price = (deal.price ?? 0) > 0
        ? '${deal.price!.toStringAsFixed(0)} UZS'
        : null;
    final duration = appt.durationMinutes > 0
        ? strings.appointmentDuration(appt.durationMinutes)
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: bandColor.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Gradient band ────────────────────────────────────────────
              SizedBox(
                height: 72,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(bandColor, Colors.white, 0.12)!,
                            bandColor,
                            Color.lerp(bandColor, Colors.black, 0.15)!,
                          ],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      end: -16,
                      bottom: -12,
                      child: ExcludeSemantics(
                        child: Icon(
                          categoryIcon,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  timeStr,
                                  style: AppTypography.largeTitle.copyWith(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${appt.serviceName} · $roleLabel',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          YbStatusBadge(label: phaseLabel, tone: phaseTone),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── Notch divider ────────────────────────────────────────────
              _Notch(fill: colors.card),
              // ── Body ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Other party row + action tiles.
                    Row(
                      children: [
                        _Avatar(
                          url: appt.otherPartyAvatar,
                          radius: 22,
                          ringColor: bandColor,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appt.otherPartyName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.body.copyWith(
                                  color: colors.ink,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                otherLabel,
                                style: AppTypography.caption.copyWith(
                                  color: colors.ink3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _ActionTile(
                          icon: YbIcons.callFilled,
                          color: colors.success,
                          onTap: onCall,
                          tooltip: strings.appointmentCall,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // "Kelishuv" tile: go to deal discussion / edit terms.
                        _ActionTile(
                          icon: YbIcons.chatBubbleFilled,
                          color: bandColor,
                          onTap: onViewDeal,
                          tooltip: strings.kelishuvTitle,
                        ),
                      ],
                    ),
                    // Facts row.
                    if (price != null || duration != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          if (price != null) ...[
                            _FactTile(
                              label: strings.appointmentFactPrice,
                              value: price,
                              color: bandSoft,
                              ink: bandColorInk,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          if (duration != null)
                            _FactTile(
                              label: strings.appointmentFactDuration,
                              value: duration,
                              color: colors.surface2,
                              ink: colors.ink,
                            ),
                        ],
                      ),
                    ],
                    // Save-client button (providers only).
                    if (onSaveClient != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: colors.teal,
                          alignment: AlignmentDirectional.centerStart,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: onSaveClient,
                        icon: const Icon(YbIcons.personAddFilled, size: 18),
                        label: Text(strings.appointmentSaveClient),
                      ),
                    ],
                    // Cancel button (active appointments only).
                    if (onConfirmCancel != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.error,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onConfirmCancel,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(YbIcons.closeFilled, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                strings.appointmentCancel,
                                style: AppTypography.caption.copyWith(
                                  color: colors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Notch extends StatelessWidget {
  const _Notch({required this.fill});
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: _DashedLinePainter(context.ybColors.line),
            ),
          ),
          Transform.translate(
            offset: const Offset(10, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..strokeWidth = 1;
    const dashWidth = 6.0;
    const gap = 4.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.radius, required this.ringColor});
  final String? url;
  final double radius;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2 + 4,
      height: radius * 2 + 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 2),
      ),
      child: ClipOval(
        child: url != null && url!.isNotEmpty
            ? YbNetworkImage(
                url: url!,
                placeholderIcon: YbIcons.personFilled,
                errorIcon: YbIcons.personFilled,
              )
            : DecoratedBox(
                decoration:
                    BoxDecoration(color: ringColor.withValues(alpha: 0.15)),
                child: Center(
                  child: Icon(YbIcons.personFilled, size: radius, color: ringColor),
                ),
              ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: YbScaleTap(
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _FactTile extends StatelessWidget {
  const _FactTile({
    required this.label,
    required this.value,
    required this.color,
    required this.ink,
  });
  final String label;
  final String value;
  final Color color;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTypography.caption.copyWith(
                color: ink.withValues(alpha: 0.6),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: AppTypography.label.copyWith(
                color: ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
