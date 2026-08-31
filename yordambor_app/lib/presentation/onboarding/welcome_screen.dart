import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/deep_link_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/onboarding/widgets/language_picker.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const YordamBorLogo(size: 120),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    strings.welcomeTitle,
                    style: AppTypography.display.copyWith(
                      color: AppColors.primary,
                      fontSize: 26,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    strings.welcomeBody,
                    style: AppTypography.bodyRegular.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 3),
                  YbPrimaryButton(
                    label: strings.startBrowsing,
                    onPressed: () async {
                      await ref
                          .read(onboardingPrefsProvider.notifier)
                          .markWelcomeSeen();
                      if (context.mounted) {
                        goAfterBootstrap(context, ref, '/home');
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  YbSecondaryButton(
                    label: strings.createAccount,
                    onPressed: () => showAuthBottomSheet(
                      context,
                      ref,
                      initialTab: AuthSheetTab.register,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
            const Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.lg,
              child: LanguagePicker(),
            ),
          ],
        ),
      ),
    );
  }
}
