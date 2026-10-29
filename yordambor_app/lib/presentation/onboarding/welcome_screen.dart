import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/deep_link_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/onboarding/widgets/language_picker.dart';
import 'package:yordambor/presentation/onboarding/widgets/onboarding_previews.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';

/// The first screen: what YordamBor is, in a picture and two words. Every
/// kind of service, from lawyers to catering and cleaning; find help, or
/// offer it. Starting leads through the short introduction; registering
/// can wait.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: YbAppBrandTitle(
                        logoSize: 28,
                        style: AppTypography.headline.copyWith(
                          color: colors.ink,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const LanguagePicker(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    // Every kind of service, as large as the screen allows.
                    const Expanded(
                      child: Center(child: FittedBox(child: WelcomeMosaic())),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _Motto(text: strings.welcomeTitle),
                    const SizedBox(height: AppSpacing.lg),
                    _HelpPaths(
                      find: strings.welcomeFindHelp,
                      give: strings.welcomeGiveHelp,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  YbPrimaryButton(
                    label: strings.startBrowsing,
                    onPressed: () async {
                      final prefs = ref.read(onboardingPrefsProvider.notifier);
                      await prefs.markWelcomeSeen();
                      if (!context.mounted) return;
                      // The short introduction comes first, once.
                      final done =
                          ref.read(onboardingPrefsProvider).onboardingDone;
                      goAfterBootstrap(context, ref, done ? '/home' : '/start');
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "YordamBor’da / Yordam bor!": the motto on two lines, the second in the
/// brand's teal. A motto without the brand name stays on one line, teal.
class _Motto extends StatelessWidget {
  const _Motto({required this.text});

  final String text;

  /// Splits after the word that holds "YordamBor" (with its suffix or a
  /// comma): "YordamBor’da" | "Yordam bor!", "On YordamBor," | "help…".
  static (String, String)? _split(String text) {
    const brand = 'YordamBor';
    final at = text.indexOf(brand);
    if (at < 0) return null;
    var end = at + brand.length;
    while (end < text.length && text[end] != ' ' && text[end] != '，') {
      end++;
    }
    if (end < text.length && text[end] == '，') end++;
    final lead = text.substring(0, end).trim();
    final rest = text.substring(end).trim();
    if (lead.isEmpty || rest.isEmpty) return null;
    return (lead, rest);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final style = AppFonts.ui(
      size: 32,
      weight: FontWeight.w700,
      height: 38 / 32,
      letterSpacing: -0.8,
      color: colors.ink,
    );
    final parts = _split(text);

    return Semantics(
      header: true,
      label: text,
      excludeSemantics: true,
      child: Text.rich(
        parts == null
            ? TextSpan(text: text, style: style.copyWith(color: colors.teal))
            : TextSpan(
                children: [
                  TextSpan(text: '${parts.$1}\n', style: style),
                  TextSpan(
                    text: parts.$2,
                    style: style.copyWith(color: colors.teal),
                  ),
                ],
              ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// The two ways to use YordamBor: find help (apricot, as asking is
/// everywhere) and offer it (teal).
class _HelpPaths extends StatelessWidget {
  const _HelpPaths({required this.find, required this.give});

  final String find;
  final String give;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xl,
      runSpacing: AppSpacing.md,
      children: [
        _HelpPath(
          icon: YbIcons.search,
          fill: colors.apricotSoft,
          ink: colors.apricotInk,
          label: find,
        ),
        _HelpPath(
          icon: YbIcons.volunteerActivismFilled,
          fill: colors.tealSoft,
          ink: colors.teal,
          label: give,
        ),
      ],
    );
  }
}

class _HelpPath extends StatelessWidget {
  const _HelpPath({
    required this.icon,
    required this.fill,
    required this.ink,
    required this.label,
  });

  final IconData icon;
  final Color fill;
  final Color ink;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: Icon(icon, size: 22, color: ink),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppFonts.ui(
            size: 16,
            weight: FontWeight.w600,
            height: 20 / 16,
            color: colors.ink,
          ),
        ),
      ],
    );
  }
}
