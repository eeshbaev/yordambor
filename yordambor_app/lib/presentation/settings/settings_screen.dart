import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/presentation/onboarding/widgets/language_picker.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isUpdatingShowPhone = false;

  Future<void> _toggleShowPhone(bool value) async {
    setState(() => _isUpdatingShowPhone = true);
    try {
      await ref.read(authRepositoryProvider).updateShowPhone(value);
      await ref.read(sessionProvider.notifier).refreshProfile();
    } on AuthFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingShowPhone = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final prefs = ref.watch(onboardingPrefsProvider);
    final session = ref.watch(sessionProvider);
    final themeMode = prefs.themeMode;

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: AppLayout.page(
        context: context,
        child: ListView(
          children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(strings.settingsAppearance, style: AppTypography.label),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(strings.settingsDarkMode),
            subtitle: Text(_themeModeLabel(strings, themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(strings.settingsThemeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(strings.settingsThemeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(strings.settingsThemeDark),
                ),
              ],
              onChanged: (mode) {
                if (mode == null) return;
                ref.read(onboardingPrefsProvider.notifier).setThemeMode(mode);
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(strings.settingsLanguage),
            trailing: const LanguagePicker(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(strings.settingsTools, style: AppTypography.label),
          ),
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: Text(strings.remindersTitle),
            subtitle: Text(strings.remindersSettingsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/reminders'),
          ),
          if (session.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(strings.settingsPrivacySection, style: AppTypography.label),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.phone_outlined),
              title: Text(strings.settingsShowPhoneLabel),
              subtitle: Text(strings.settingsShowPhoneSubtitle),
              value: session.profile?.showPhone ?? false,
              onChanged: _isUpdatingShowPhone ? null : _toggleShowPhone,
            ),
          ],
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(strings.settingsHelp),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/help'),
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(strings.settingsSafety),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/legal/safety'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(strings.settingsLegal, style: AppTypography.label),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(strings.settingsPrivacy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/legal/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(strings.settingsTerms),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/legal/terms'),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: AppColors.error),
            title: Text(
              strings.settingsDeleteAccount,
              style: TextStyle(color: AppColors.error),
            ),
            subtitle: Text(strings.settingsDeleteAccountHint),
            onTap: () => _deleteAccount(context, ref, strings),
          ),
        ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
  ) async {
    final confirmed = await showYbConfirmDialog(
      context,
      title: strings.settingsDeleteAccount,
      message: strings.settingsDeleteAccountConfirm,
      confirmLabel: strings.settingsDeleteAccountAction,
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(sessionProvider.notifier).deleteAccount();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.settingsDeleteAccountDone)),
        );
        context.go('/welcome');
      }
    } on AuthFailure catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  String _themeModeLabel(AppStrings strings, ThemeMode mode) => switch (mode) {
        ThemeMode.dark => strings.settingsThemeDark,
        ThemeMode.light => strings.settingsThemeLight,
        ThemeMode.system => strings.settingsThemeSystem,
      };
}
