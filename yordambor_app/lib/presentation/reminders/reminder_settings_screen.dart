import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_filter_chip.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

/// When reminders ring: before the appointment (1 day, 3 hours, 1 hour,
/// 15 minutes, at the time) and the checks after it, each a chip to tap.
class ReminderSettingsScreen extends ConsumerStatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  ConsumerState<ReminderSettingsScreen> createState() =>
      _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState
    extends ConsumerState<ReminderSettingsScreen> {
  Set<int> _alerts = {};
  Set<int> _followUps = {};
  bool _loaded = false;
  bool _saving = false;
  bool _showMissing = false;

  void _apply(ReminderSettings settings) {
    if (_loaded) return;
    _alerts = settings.alertMinutesBefore.toSet();
    _followUps = settings.followUpHoursAfter.toSet();
    _loaded = true;
  }

  /// The presets, plus any other time saved before presets existed, so
  /// nothing saved disappears from view.
  static List<int> _choices(List<int> presets, Set<int> selected) =>
      {...presets, ...selected}.toList();

  void _toggle(Set<int> set, int value) {
    setState(() {
      if (!set.remove(value)) set.add(value);
      _showMissing = false;
    });
  }

  Future<void> _save(ReminderSettings settings) async {
    if (_alerts.isEmpty) {
      AppHaptics.error();
      setState(() => _showMissing = true);
      return;
    }
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final strings = ref.read(appStringsProvider);
    try {
      await ref.read(remindersRepositoryProvider).saveSettings(
            settings.copyWith(
              alertMinutesBefore: _alerts.toList()
                ..sort((a, b) => b.compareTo(a)),
              followUpHoursAfter: _followUps.toList()..sort(),
            ),
          );
      ref.invalidate(reminderSettingsProvider);
      AppHaptics.success();
      if (mounted) navigator.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(strings.stateErrorBody)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final settingsAsync = ref.watch(reminderSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.remindersSettingsTitle)),
      body: AppLayout.page(
        context: context,
        child: settingsAsync.when(
          loading: () => const YbSkeletonList(count: 3),
          error: (_, _) => YbEmptyState(
            icon: YbIcons.cloudOff,
            title: strings.stateErrorTitle,
            subtitle: strings.stateErrorBody,
            actionLabel: strings.actionRetry,
            onAction: () => ref.invalidate(reminderSettingsProvider),
          ),
          data: (settings) {
            _apply(settings);
            final alertChoices =
                _choices(ReminderSettings.alertPresets, _alerts)
                  ..sort((a, b) => b.compareTo(a));
            final followUpChoices =
                _choices(ReminderSettings.followUpPresets, _followUps)..sort();

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _SectionTitle(text: strings.remindersSettingsAlertsLabel),
                const SizedBox(height: AppSpacing.md),
                _ChipRow(
                  children: [
                    for (final minutes in alertChoices)
                      YbFilterChip(
                        label: strings.reminderLead(minutes),
                        selected: _alerts.contains(minutes),
                        onTap: () => _toggle(_alerts, minutes),
                      ),
                  ],
                ),
                if (_showMissing) ...[
                  const SizedBox(height: AppSpacing.sm),
                  YbInlineMessage(message: strings.remindersSettingsPickOne),
                ],
                const SizedBox(height: AppSpacing.xl),
                _SectionTitle(text: strings.remindersSettingsFollowUpLabel),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  strings.remindersSettingsFollowUpHint,
                  style: AppTypography.caption.copyWith(
                    color: context.ybColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _ChipRow(
                  children: [
                    for (final hours in followUpChoices)
                      YbFilterChip(
                        label: strings.reminderFollowUpAfterHours(hours),
                        selected: _followUps.contains(hours),
                        onTap: () => _toggle(_followUps, hours),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                YbPrimaryButton(
                  label: strings.actionSave,
                  isLoading: _saving,
                  onPressed: _saving ? null : () => _save(settings),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: AppTypography.headline.copyWith(
          color: context.ybColors.textPrimary,
        ),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: children,
    );
  }
}
