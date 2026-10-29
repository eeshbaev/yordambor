import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/schedule_calendar_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/calendar/widgets/working_hours_sheet.dart';

/// Everything about when a provider can take work for one service, in one
/// sheet: the status clients see, until when, the working hours, and
/// whether their appointments show as busy hours.
Future<void> showServiceAvailabilitySheet(
  BuildContext context,
  WidgetRef ref, {
  required XizmatFeedItem item,
}) {
  return showModalBottomSheet<void>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _ServiceAvailabilitySheet(item: item),
  );
}

/// The four choices, the last one hiding the status.
enum _Choice { now, busy, booking, hidden }

/// How long "now" or "busy" holds.
enum _Until { hour, today, open }

class _ServiceAvailabilitySheet extends ConsumerStatefulWidget {
  const _ServiceAvailabilitySheet({required this.item});

  final XizmatFeedItem item;

  @override
  ConsumerState<_ServiceAvailabilitySheet> createState() =>
      _ServiceAvailabilitySheetState();
}

class _ServiceAvailabilitySheetState
    extends ConsumerState<_ServiceAvailabilitySheet> {
  late _Choice _choice;
  late _Until _until;
  bool? _showBusy;
  bool _initialShowBusy = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    final active = isXizmatAvailabilityActive(item);
    _choice = !active
        ? _Choice.hidden
        : switch (item.availabilityMode!) {
            XizmatAvailabilityMode.availableNow => _Choice.now,
            XizmatAvailabilityMode.busy => _Choice.busy,
            XizmatAvailabilityMode.callMe => _Choice.booking,
          };
    final until = item.availabilityUntil;
    final now = DateTime.now();
    _until = until == null
        ? _Until.open
        : until.difference(now) <= const Duration(minutes: 65)
            ? _Until.hour
            : _Until.today;
    _loadShowBusy();
  }

  Future<void> _loadShowBusy() async {
    final value = await ref
        .read(xizmatRepositoryProvider)
        .fetchShowBusyHours(widget.item.id);
    if (!mounted) return;
    setState(() {
      _initialShowBusy = value;
      _showBusy ??= value;
    });
  }

  DateTime? _untilTime() {
    final now = DateTime.now();
    return switch (_until) {
      _Until.hour => now.add(const Duration(hours: 1)),
      _Until.today => DateTime(now.year, now.month, now.day, 23, 59),
      _Until.open => null,
    };
  }

  XizmatAvailabilityMode? get _mode => switch (_choice) {
        _Choice.now => XizmatAvailabilityMode.availableNow,
        _Choice.busy => XizmatAvailabilityMode.busy,
        _Choice.booking => XizmatAvailabilityMode.callMe,
        _Choice.hidden => null,
      };

  bool get _hasWindow => _choice == _Choice.now || _choice == _Choice.busy;

  Future<void> _save() async {
    final strings = ref.read(appStringsProvider);
    final repo = ref.read(xizmatRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _saving = true);
    try {
      await repo.updateAvailability(
        widget.item.id,
        visible: _choice != _Choice.hidden,
        mode: _mode,
        until: _hasWindow ? _untilTime() : null,
      );
      final showBusy = _showBusy;
      if (showBusy != null && showBusy != _initialShowBusy) {
        await repo.setShowBusyHours(widget.item.id, showBusy);
      }
      AppHaptics.success();
      ref.invalidate(myXizmatlarProvider);
      ref.invalidate(xizmatDetailProvider(widget.item.id));
      ref.invalidate(xizmatBusyHoursProvider(widget.item.id));
      ref.read(feedProvider.notifier).load();
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(strings.availabilitySaved)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(strings.stateErrorBody)));
    }
  }

  Future<void> _editHours(WorkingHours current, bool own) async {
    final strings = ref.read(appStringsProvider);
    final picked = await showWorkingHoursSheet(
      context,
      strings: strings,
      initial: current,
    );
    if (picked == null || !mounted) return;
    final userId = ref.read(sessionProvider).user?.id;
    if (userId == null) return;
    final repo = ref.read(workingHoursRepositoryProvider);
    try {
      if (own) {
        await repo.saveForXizmat(widget.item.id, picked);
        ref.invalidate(xizmatOwnHoursProvider(widget.item.id));
      } else {
        await repo.saveForUser(userId, picked);
        ref.invalidate(myWorkingHoursProvider);
        ref.invalidate(userWorkingHoursProvider(userId));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.stateErrorBody)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final item = widget.item;
    final ownHours = ref.watch(xizmatOwnHoursProvider(item.id)).valueOrNull;
    final sharedHours =
        ref.watch(myWorkingHoursProvider).valueOrNull ?? WorkingHours.standard;
    final hours = ownHours ?? sharedHours;
    final categoryIcon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox.square(
                  dimension: 52,
                  child: YbNetworkImage(
                    url: item.galleryUrls.isNotEmpty
                        ? item.galleryUrls.first
                        : '',
                    placeholderIcon: categoryIcon,
                    errorIcon: categoryIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.serviceDisplayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.title.copyWith(
                        color: colors.ink,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      strings.availabilitySheetCaption,
                      style: AppTypography.caption.copyWith(
                        color: colors.ink3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm + 2,
            crossAxisSpacing: AppSpacing.sm + 2,
            childAspectRatio: 1.35,
            children: [
              _StatusTile(
                icon: YbIcons.boltFilled,
                label: strings.xizmatAvailabilityAvailableNow,
                hint: strings.availabilityTileNowHint,
                accent: colors.success,
                soft: colors.successSoft,
                selected: _choice == _Choice.now,
                onTap: () => setState(() => _choice = _Choice.now),
              ),
              _StatusTile(
                icon: YbIcons.hourglassTopFilled,
                label: strings.xizmatAvailabilityBusy,
                hint: strings.availabilityTileBusyHint,
                accent: colors.apricotInk,
                soft: colors.apricotSoft,
                selected: _choice == _Choice.busy,
                onTap: () => setState(() => _choice = _Choice.busy),
              ),
              _StatusTile(
                icon: YbIcons.eventAvailableFilled,
                label: strings.xizmatAvailabilityCallMe,
                hint: strings.availabilityTileBookingHint,
                accent: colors.teal,
                soft: colors.tealSoft,
                selected: _choice == _Choice.booking,
                onTap: () => setState(() => _choice = _Choice.booking),
              ),
              _StatusTile(
                icon: YbIcons.visibilityOffFilled,
                label: strings.availabilityTileHidden,
                hint: strings.availabilityTileHiddenHint,
                accent: colors.ink3,
                soft: colors.surface2,
                selected: _choice == _Choice.hidden,
                onTap: () => setState(() => _choice = _Choice.hidden),
              ),
            ],
          ),
          AnimatedSize(
            duration: AppMotion.of(context, AppMotion.standardDuration),
            curve: AppMotion.standard,
            alignment: Alignment.topCenter,
            child: !_hasWindow
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Label(strings.availabilityUntilTitle),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            for (final (index, until) in _Until.values.indexed) ...[
                              if (index > 0) const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _UntilChip(
                                  label: switch (until) {
                                    _Until.hour => strings.availabilityUntilHour,
                                    _Until.today =>
                                      strings.availabilityUntilToday,
                                    _Until.open =>
                                      strings.availabilityUntilForever,
                                  },
                                  selected: _until == until,
                                  onTap: () => setState(() => _until = until),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Label(strings.availabilityHoursTitle),
          const SizedBox(height: AppSpacing.sm),
          _HoursRow(
            hours: hours,
            caption: ownHours != null
                ? strings.availabilityHoursOwn
                : strings.availabilityHoursShared,
            editLabel: strings.actionEdit,
            onEdit: () => _editHours(hours, ownHours != null),
          ),
          const SizedBox(height: AppSpacing.md),
          _BusyHoursSwitch(
            value: _showBusy ?? false,
            title: strings.availabilityBusyToggle,
            subtitle: strings.availabilityBusyToggleHint,
            onChanged: _showBusy == null
                ? null
                : (value) {
                    AppHaptics.select();
                    setState(() => _showBusy = value);
                  },
          ),
          const SizedBox(height: AppSpacing.md),
          _Preview(
            label: strings.availabilityPreview,
            badge: _previewBadge(strings),
          ),
          const SizedBox(height: AppSpacing.lg),
          YbPrimaryButton(
            label: strings.actionSave,
            isLoading: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }

  Widget _previewBadge(AppStrings strings) {
    final mode = _mode;
    if (mode == null) {
      return YbStatusBadge(label: strings.availabilityHiddenPreview);
    }
    final base = switch (mode) {
      XizmatAvailabilityMode.availableNow =>
        strings.xizmatAvailabilityAvailableNow,
      XizmatAvailabilityMode.busy => strings.xizmatAvailabilityBusy,
      XizmatAvailabilityMode.callMe => strings.xizmatAvailabilityCallMe,
    };
    final until = _hasWindow ? _untilTime() : null;
    final label = until == null
        ? base
        : '$base${strings.xizmatAvailabilityUntilSuffix(formatAvailabilityTime(until))}';
    final tone = switch (mode) {
      XizmatAvailabilityMode.availableNow => YbStatusTone.success,
      XizmatAvailabilityMode.busy => YbStatusTone.warning,
      XizmatAvailabilityMode.callMe => YbStatusTone.primary,
    };
    return AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.quick),
      child: YbStatusBadge(key: ValueKey(label), label: label, tone: tone),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTypography.label.copyWith(
        color: context.ybColors.ink2,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }
}

/// A status as a little picture card; chosen, it lifts and gets a tick.
class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.label,
    required this.hint,
    required this.accent,
    required this.soft,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String hint;
  final Color accent;
  final Color soft;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final duration = AppMotion.of(context, AppMotion.quick);

    return Semantics(
      button: true,
      selected: selected,
      label: '$label. $hint',
      excludeSemantics: true,
      child: YbScaleTap(
        onTap: () {
          AppHaptics.select();
          onTap();
        },
        child: AnimatedContainer(
          duration: duration,
          curve: AppMotion.quickCurve,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? colors.card : colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accent : Colors.transparent,
              width: 2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      spreadRadius: -8,
                    ),
                  ]
                : const [],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TileArt(icon: icon, accent: accent, soft: soft, lit: selected),
                  const Spacer(),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.body.copyWith(
                      color: colors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(
                      color: colors.ink3,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: 0,
                end: 0,
                child: AnimatedScale(
                  scale: selected ? 1 : 0,
                  duration: duration,
                  curve: AppMotion.snap,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        YbIcons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The tile's picture: a soft rounded square with the icon and two sparks
/// that light up when chosen.
class _TileArt extends StatelessWidget {
  const _TileArt({
    required this.icon,
    required this.accent,
    required this.soft,
    required this.lit,
  });

  final IconData icon;
  final Color accent;
  final Color soft;
  final bool lit;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.standardDuration);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: 46,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: duration,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      soft,
                      Color.lerp(soft, accent, lit ? 0.28 : 0.1)!,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: AnimatedScale(
                scale: lit ? 1.12 : 1,
                duration: duration,
                curve: AppMotion.spring,
                child: Icon(icon, color: accent, size: 24),
              ),
            ),
            AnimatedPositioned(
              duration: duration,
              curve: AppMotion.spring,
              right: lit ? -6 : -2,
              top: lit ? -5 : 0,
              child: AnimatedOpacity(
                duration: duration,
                opacity: lit ? 1 : 0.35,
                child: _Spark(color: accent, size: 7),
              ),
            ),
            AnimatedPositioned(
              duration: duration,
              curve: AppMotion.spring,
              left: lit ? -5 : -1,
              bottom: lit ? 2 : 6,
              child: AnimatedOpacity(
                duration: duration,
                opacity: lit ? 0.8 : 0.25,
                child: _Spark(color: accent, size: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spark extends StatelessWidget {
  const _Spark({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _UntilChip extends StatelessWidget {
  const _UntilChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return Semantics(
      button: true,
      selected: selected,
      child: YbScaleTap(
        onTap: () {
          AppHaptics.select();
          onTap();
        },
        child: AnimatedContainer(
          duration: AppMotion.of(context, AppMotion.quick),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.tealSoft : colors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? colors.teal : colors.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.label.copyWith(
              color: selected ? colors.tealInk : colors.ink,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoursRow extends StatelessWidget {
  const _HoursRow({
    required this.hours,
    required this.caption,
    required this.editLabel,
    required this.onEdit,
  });

  final WorkingHours hours;
  final String caption;
  final String editLabel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(YbIcons.scheduleFilled, color: colors.teal),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hours.label,
                      style: AppTypography.tabular(
                        AppTypography.body.copyWith(
                          color: colors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      caption,
                      style: AppTypography.caption.copyWith(color: colors.ink3),
                    ),
                  ],
                ),
              ),
              Text(
                editLabel,
                style: AppTypography.label.copyWith(
                  color: colors.teal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusyHoursSwitch extends StatelessWidget {
  const _BusyHoursSwitch({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final String title;
  final String subtitle;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        secondary: Icon(YbIcons.eventBusyFilled, color: colors.error),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            color: colors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.caption.copyWith(color: colors.ink3),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.label, required this.badge});

  final String label;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [colors.tealSoft, colors.card]),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Row(
          children: [
            Icon(YbIcons.visibilityFilled, color: colors.teal, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: colors.ink2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(child: badge),
          ],
        ),
      ),
    );
  }
}
