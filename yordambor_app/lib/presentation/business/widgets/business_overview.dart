import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/constants/xizmat_limits.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// No services yet: one card that says why it is worth it, and the one
/// button to start (the services list and its add button come later).
class BusinessStartSelling extends ConsumerWidget {
  const BusinessStartSelling({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.tealSoft,
            Color.lerp(colors.tealSoft, colors.teal, 0.15)!,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Icon(
                    YbIcons.storefrontFilled,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.businessEmptyTitle,
              style: AppTypography.title.copyWith(
                color: colors.tealInk,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              strings.businessEmptyBody,
              style: AppTypography.bodyRegular.copyWith(
                color: colors.tealInk.withValues(alpha: 0.8),
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            YbPrimaryButton(
              label: strings.createXizmat,
              icon: YbIcons.addFilled,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

/// "My services · 2 of 5", with the add button while there is room.
class BusinessServicesHeader extends ConsumerWidget {
  const BusinessServicesHeader({
    super.key,
    required this.count,
    required this.onCreate,
  });

  final int count;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final full = count >= XizmatLimits.maxPerAccount;

    return Row(
      children: [
        Expanded(
          child: Text(
            strings.businessServicesCount(count, XizmatLimits.maxPerAccount),
            style: AppTypography.headline.copyWith(color: colors.ink),
          ),
        ),
        if (!full)
          TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(YbIcons.addFilled, size: 18),
            label: Text(strings.actionAdd),
          ),
      ],
    );
  }
}
