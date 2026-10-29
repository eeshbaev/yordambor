import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/growth/growth_program_providers.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/presentation/onboarding/widgets/language_picker.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

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
            child: Text(strings.settingsAppearance, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
          ),
          ListTile(
            leading: const Icon(YbIcons.darkMode),
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
            leading: const Icon(YbIcons.language),
            title: Text(strings.settingsLanguage),
            trailing: const LanguagePicker(),
          ),
          if (session.isAuthenticated) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(strings.settingsPrivacySection, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
            ),
            SwitchListTile(
              secondary: const Icon(YbIcons.phone),
              title: Text(strings.settingsShowPhoneLabel),
              subtitle: Text(strings.settingsShowPhoneSubtitle),
              value: session.profile?.showPhone ?? false,
              onChanged: _isUpdatingShowPhone ? null : _toggleShowPhone,
            ),
            // The 30-day tips after a first service, back on after "turn
            // off" on a tip.
            SwitchListTile(
              secondary: const Icon(YbIcons.tipsAndUpdatesFilled),
              title: Text(strings.growthTipsSetting),
              subtitle: Text(strings.growthTipsSettingSub),
              value: ref.watch(growthTipsEnabledProvider),
              onChanged: (value) =>
                  ref.read(growthTipsEnabledProvider.notifier).set(value),
            ),
          ],
          ListTile(
            leading: const Icon(YbIcons.help),
            title: Text(strings.settingsHelp),
            trailing: const Icon(YbIcons.chevronRightFilled),
            onTap: () => context.push('/settings/help'),
          ),
          ListTile(
            leading: const Icon(YbIcons.shield),
            title: Text(strings.settingsSafety),
            trailing: const Icon(YbIcons.chevronRightFilled),
            onTap: () => context.push('/legal/safety'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(strings.settingsLegal, style: AppTypography.label.copyWith(color: context.ybColors.textSecondary)),
          ),
          ListTile(
            leading: const Icon(YbIcons.privacyTip),
            title: Text(strings.settingsPrivacy),
            trailing: const Icon(YbIcons.chevronRightFilled),
            onTap: () => context.push('/legal/privacy'),
          ),
          ListTile(
            leading: const Icon(YbIcons.description),
            title: Text(strings.settingsTerms),
            trailing: const Icon(YbIcons.chevronRightFilled),
            onTap: () => context.push('/legal/terms'),
          ),
          ListTile(
            leading: Icon(YbIcons.deleteForever, color: context.ybColors.error),
            title: Text(
              strings.settingsDeleteAccount,
              style: TextStyle(color: context.ybColors.error),
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
