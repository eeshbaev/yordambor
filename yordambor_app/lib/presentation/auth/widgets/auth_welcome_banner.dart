import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

class AuthWelcomeBanner extends ConsumerWidget {
  const AuthWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(authWelcomeProvider);
    if (message == null) return const SizedBox.shrink();

    final strings = ref.watch(appStringsProvider);
    final isYordamKerak =
        ref.watch(feedFilterProvider).mode == FeedMode.yordamKerak;
    final colors = context.ybColors;
    final name = message.displayName.isNotEmpty
        ? message.displayName
        : strings.welcomeGuestName;

    final (title, body, icon) = switch (message.kind) {
      AuthWelcomeKind.newMember => (
          strings.welcomeNewTitle(name),
          strings.welcomeNewBody,
          Icons.celebration_outlined,
        ),
      AuthWelcomeKind.returningLogin => (
          strings.welcomeLoginTitle(name),
          strings.welcomeLoginBody,
          Icons.waving_hand_outlined,
        ),
      AuthWelcomeKind.returningSession => (
          isYordamKerak
              ? strings.homeGreetingYordamKerak
              : strings.homeGreetingYordamBor,
          isYordamKerak
              ? strings.welcomeReturnBodyYordamKerak
              : strings.welcomeReturnBody,
          Icons.favorite_outline,
        ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Material(
        color: colors.primaryMuted,
        borderRadius: BorderRadius.circular(AppRadius.card),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            boxShadow: AppElevation.card(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.title.copyWith(
                          color: colors.textPrimary,
                          fontSize: 18,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        body,
                        style: AppTypography.bodyRegular.copyWith(
                          color: colors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    ref.read(authWelcomeProvider.notifier).state = null;
                  },
                  icon: Icon(Icons.close_rounded, size: 20, color: colors.textTertiary),
                  tooltip: strings.actionCancel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
