import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';

/// The ticket-style appointment card. Swipe left on an active one to
/// reveal "cancel"; a grey version shows done or cancelled ones.
class AppointmentPass extends ConsumerStatefulWidget {
  const AppointmentPass({
    super.key,
    required this.appt,
    required this.strings,
    required this.onCancel,
    required this.onSaveClient,
  });

  final CalendarAppointment appt;
  final AppStrings strings;

  /// Confirm and cancel the appointment.
  final VoidCallback onCancel;

  /// Prompt the provider to save this client.
  final VoidCallback? onSaveClient;

  @override
  ConsumerState<AppointmentPass> createState() => _AppointmentPassState();
}

class _AppointmentPassState extends ConsumerState<AppointmentPass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _reveal;

  static const _revealWidth = 118.0;
  bool _swipeOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.standardDuration,
    );
    _reveal = CurvedAnimation(parent: _controller, curve: AppMotion.standard);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSwipe() {
    if (_swipeOpen) {
      _controller.reverse();
      _swipeOpen = false;
    } else {
      AppHaptics.select();
      _controller.forward();
      _swipeOpen = true;
    }
  }

  void _close() {
    _controller.reverse();
    _swipeOpen = false;
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  Future<void> _confirmCancel() async {
    _close();
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
    if (confirmed == true) widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final appt = widget.appt;
    final strings = widget.strings;
    final colors = context.ybColors;
    final locale = ref.watch(appStringsProvider).languageCode;
    final phase = appt.phaseAt(DateTime.now());
    final isActive = appt.isActive;
    final isCancelled = appt.isCancelled;
    final isDone = appt.isDone;

    // The pass's gradient band: teal for "I do it", apricot for "I need it".
    final bandColor = appt.iProvide ? colors.teal : colors.apricot;
    final bandColorInk = appt.iProvide ? colors.tealInk : colors.apricotInk;
    final bandSoft = appt.iProvide ? colors.tealSoft : colors.apricotSoft;

    // Greyed out when done or cancelled.
    final dimmed = isCancelled || isDone;
    final opacity = dimmed ? 0.55 : 1.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Stack(
        children: [
          // "Cancel" revealed by swiping.
          if (isActive)
            Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Container(
                    width: _revealWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.error.withValues(alpha: 0.8),
                          colors.error,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          YbIcons.eventBusyFilled,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.appointmentCancel,
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          AnimatedBuilder(
            animation: _reveal,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_revealWidth * _reveal.value, 0),
              child: child,
            ),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (!isActive) return;
                final velocity = details.primaryVelocity ?? 0;
                if (velocity < -400) {
                  _controller.forward();
                  _swipeOpen = true;
                  AppHaptics.select();
                } else if (velocity > 400) {
                  _controller.reverse();
                  _swipeOpen = false;
                }
              },
              onTap: _swipeOpen ? _close : null,
              child: Opacity(
                opacity: opacity,
                child: YbScaleTap(
                  onTap: _swipeOpen
                      ? _close
                      : () => context.push('/kelishuv/${appt.id}'),
                  child: _PassCard(
                    appt: appt,
                    strings: strings,
                    phase: phase,
                    bandColor: bandColor,
                    bandColorInk: bandColorInk,
                    bandSoft: bandSoft,
                    locale: locale,
                    colors: colors,
                    onCall: appt.dealPhone != null
                        ? () => _call(appt.dealPhone!)
                        : () => ref
                            .read(
                              publicPhoneProvider(appt.otherPartyId).future,
                            )
                            .then(
                              (phone) =>
                                  phone != null ? _call(phone) : null,
                            ),
                    onSwipe: isActive ? _toggleSwipe : null,
                    onConfirmCancel: isActive ? _confirmCancel : null,
                    onSaveClient: widget.onSaveClient,
                  ),
                ),
              ),
            ),
          ),
          // Swipe target outside the card.
          if (isActive && _swipeOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _close,
              ),
            ),
        ],
      ),
    );
  }
}

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
    required this.onCall,
    required this.onSwipe,
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
  final VoidCallback onCall;
  final VoidCallback? onSwipe;
  final VoidCallback? onConfirmCancel;
  final VoidCallback? onSaveClient;

  @override
  Widget build(BuildContext context) {
    final deal = appt.deal;
    final categoryIcon = CategoryIcons.forService(
      categoryId: deal.serviceCategoryId,
      subcategoryId: deal.serviceSubcategoryId,
    );

    // Phase chip label.
    final (phaseLabel, phaseTone) = switch (phase) {
      AppointmentPhase.now => (strings.appointmentPhaseNow, YbStatusTone.success),
      AppointmentPhase.today =>
        (strings.appointmentPhaseToday, YbStatusTone.primary),
      AppointmentPhase.planned =>
        (strings.appointmentPhasePlanned, YbStatusTone.neutral),
      AppointmentPhase.past => (
          strings.appointmentPhasePast,
          YbStatusTone.warning,
        ),
      AppointmentPhase.done => (strings.appointmentPhaseDone, YbStatusTone.success),
      AppointmentPhase.cancelled => (
          strings.appointmentPhaseCancelled,
          YbStatusTone.neutral,
        ),
    };

    // Time range.
    final timeFmt = DateFormat.Hm(locale);
    final timeStr = appt.hasTime
        ? '${timeFmt.format(appt.startsAt)} – ${timeFmt.format(appt.endsAt)}'
        : DateFormat.yMMMMd(locale).format(appt.startsAt);

    // Role line.
    final roleLabel = appt.iProvide
        ? strings.appointmentRoleProvider
        : strings.appointmentRoleClient;

    // Other party line.
    final otherName = appt.otherPartyName;
    final otherLabel = appt.iProvide
        ? strings.appointmentPartyClient
        : strings.appointmentPartyProvider;

    // Price and duration facts.
    final price = (deal.price ?? 0) > 0
        ? '${deal.price!.toStringAsFixed(0)} UZS'
        : null;
    final duration = appt.durationMinutes > 0
        ? strings.appointmentDuration(appt.durationMinutes)
        : null;

    return DecoratedBox(
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
            // Gradient band with watermark icon.
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
                        // Phase chip.
                        YbStatusBadge(label: phaseLabel, tone: phaseTone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Notch divider.
            _Notch(fill: colors.surface),
            // Body: other party, facts, actions.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Other party row with avatar.
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
                              otherName,
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
                      // Action tiles: call and chat.
                      _ActionTile(
                        icon: YbIcons.callFilled,
                        color: colors.success,
                        onTap: onCall,
                        tooltip: strings.appointmentCall,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _ActionTile(
                        icon: YbIcons.chatBubbleFilled,
                        color: bandColor,
                        onTap: () => context.push('/kelishuv/${appt.id}'),
                        tooltip: strings.actionChat,
                      ),
                    ],
                  ),
                  // Facts row: price, duration.
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
                  // Save-client button (providers only, not yet saved).
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
                  // Swipe hint.
                  if (onSwipe != null) ...[
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
    );
  }
}

/// The ticket-stub notch: two circles on the edge of the divider.
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
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.ybColors.line.withValues(alpha: 0.5),
                    style: BorderStyle.none,
                  ),
                ),
              ),
              child: CustomPaint(painter: _DashedLinePainter(context.ybColors.line)),
            ),
          ),
          Transform.translate(
            offset: const Offset(10, 0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
              ),
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
                decoration: BoxDecoration(
                  color: ringColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    YbIcons.personFilled,
                    size: radius,
                    color: ringColor,
                  ),
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
