import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';

class ProviderPromptCard extends ConsumerWidget {
  const ProviderPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return YbSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.providerPromptTitle,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.providerPromptBody,
            style: AppTypography.bodyRegular.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          YbPrimaryButton(
            label: strings.createXizmat,
            icon: Icons.add_rounded,
            onPressed: () async {
              await ref
                  .read(onboardingPrefsProvider.notifier)
                  .dismissProviderPrompt();
              if (!context.mounted) return;
              final allowed = await requireVerifiedAuth(context, ref);
              if (allowed && context.mounted) {
                context.push('/create-xizmat');
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {
              ref.read(onboardingPrefsProvider.notifier).dismissProviderPrompt();
            },
            child: Text(strings.later),
          ),
        ],
      ),
    );
  }
}
