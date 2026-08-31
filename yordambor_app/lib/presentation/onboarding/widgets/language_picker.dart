import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  static const _languageFlags = {
    'uz': '🇺🇿',
    'ru': '🇷🇺',
    'en': '🇬🇧',
    'zh': '🇨🇳',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(onboardingPrefsProvider).language;
    final colors = context.ybColors;

    return PopupMenuButton<String>(
      initialValue: language,
      tooltip: '',
      offset: const Offset(0, AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: colors.border),
      ),
      color: colors.card,
      elevation: 8,
      shadowColor: colors.overlay,
      onSelected: (code) {
        AppHaptics.selection();
        ref.read(onboardingPrefsProvider.notifier).setLanguage(code);
      },
      itemBuilder: (context) => AppStrings.supportedLanguages
          .map(
            (code) => PopupMenuItem<String>(
              value: code,
              height: 48,
              child: Row(
                children: [
                  Text(
                    _languageFlags[code] ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      AppStrings.languageLabel(code),
                      style: AppTypography.body.copyWith(
                        color: code == language
                            ? AppColors.primaryDark
                            : colors.textPrimary,
                        fontWeight:
                            code == language ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (code == language)
                    const Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.overlay.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                language.toUpperCase(),
                style: AppTypography.label.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              Icon(
                Icons.expand_more_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
