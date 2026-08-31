import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_filter_chip.dart';
import 'package:yordambor/domain/entities/reminder_settings.dart';

class ReminderSettingsScreen extends ConsumerStatefulWidget {
  const ReminderSettingsScreen({super.key});

  static const alertPresets = <int>[360, 120, 60, 30, 0];

  @override
  ConsumerState<ReminderSettingsScreen> createState() =>
      _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState
    extends ConsumerState<ReminderSettingsScreen> {
  late final TextEditingController _minutesController;
  late final TextEditingController _followUpController;
  Set<int> _selectedPresets = {};
  Set<int> _selectedFollowUp = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _minutesController = TextEditingController();
    _followUpController = TextEditingController();
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  void _applySettings(ReminderSettings settings) {
    if (_loaded) return;
    _selectedPresets = settings.alertMinutesBefore.toSet();
    _selectedFollowUp = settings.followUpHoursAfter.toSet();
    _minutesController.text = settings.alertMinutesBefore.join(', ');
    _followUpController.text = settings.followUpHoursAfter.join(', ');
    _loaded = true;
  }

  List<int> _parseFollowUpHours() {
    final fromField = _followUpController.text
        .split(',')
        .map((part) => int.tryParse(part.trim()))
        .whereType<int>()
        .where((value) => value >= 0)
        .toSet();

    if (fromField.isNotEmpty) {
      return fromField.toList()..sort();
    }
    return _selectedFollowUp.toList()..sort();
  }

  List<int> _parseMinutes() {
    final fromField = _minutesController.text
        .split(',')
        .map((part) => int.tryParse(part.trim()))
        .whereType<int>()
        .where((value) => value >= 0)
        .toSet();

    if (fromField.isNotEmpty) return fromField.toList()..sort((a, b) => b.compareTo(a));
    return _selectedPresets.toList()..sort((a, b) => b.compareTo(a));
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (settings) {
            _applySettings(settings);

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  strings.remindersSettingsAlertsLabel,
                  style: AppTypography.headline,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: ReminderSettingsScreen.alertPresets.map((minutes) {
                    final label = switch (minutes) {
                      360 => '6h',
                      120 => '2h',
                      60 => '1h',
                      30 => '30m',
                      _ => strings.remindersSettingsAtTime,
                    };
                    final selected = _selectedPresets.contains(minutes);
                    return YbFilterChip(
                      label: label,
                      selected: selected,
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _selectedPresets.remove(minutes);
                          } else {
                            _selectedPresets.add(minutes);
                          }
                          _minutesController.text =
                              (_selectedPresets.toList()
                                    ..sort((a, b) => b.compareTo(a)))
                                  .join(', ');
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _minutesController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: strings.remindersSettingsAlertsLabel,
                    hintText: '360, 120, 60, 30, 0',
                  ),
                  onChanged: (_) {
                    final parsed = _minutesController.text
                        .split(',')
                        .map((part) => int.tryParse(part.trim()))
                        .whereType<int>()
                        .where((value) => value >= 0)
                        .toSet();
                    setState(() => _selectedPresets = parsed);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  strings.remindersSettingsFollowUpLabel,
                  style: AppTypography.headline,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [1, 2, 24].map((hours) {
                    final label = hours == 24 ? '24h' : '${hours}h';
                    final selected = _selectedFollowUp.contains(hours);
                    return YbFilterChip(
                      label: label,
                      selected: selected,
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _selectedFollowUp.remove(hours);
                          } else {
                            _selectedFollowUp.add(hours);
                          }
                          _followUpController.text =
                              (_selectedFollowUp.toList()..sort()).join(', ');
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _followUpController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: strings.remindersSettingsFollowUpLabel,
                    hintText: '1, 2, 24',
                  ),
                  onChanged: (_) {
                    final parsed = _followUpController.text
                        .split(',')
                        .map((part) => int.tryParse(part.trim()))
                        .whereType<int>()
                        .where((value) => value >= 0)
                        .toSet();
                    setState(() => _selectedFollowUp = parsed);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                YbPrimaryButton(
                  label: strings.actionSave,
                  onPressed: () async {
                    final minutes = _parseMinutes();
                    final followUp = _parseFollowUpHours();
                    if (minutes.isEmpty || followUp.isEmpty) return;

                    await ref.read(remindersRepositoryProvider).saveSettings(
                          settings.copyWith(
                            alertMinutesBefore: minutes,
                            followUpHoursAfter: followUp,
                          ),
                        );
                    ref.invalidate(reminderSettingsProvider);

                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
