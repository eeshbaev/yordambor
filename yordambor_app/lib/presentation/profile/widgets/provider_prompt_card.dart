import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';

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
            icon: YbIcons.addFilled,
            onPressed: () async {
              await ref
                  .read(onboardingPrefsProvider.notifier)
                  .dismissProviderPrompt();
              if (!context.mounted) return;
              await openCreateXizmat(context, ref);
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
