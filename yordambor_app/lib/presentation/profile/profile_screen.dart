import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_profile_menu.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/domain/growth/achievement.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/growth/widgets/achievements_chip_grid.dart';
import 'package:yordambor/presentation/profile/widgets/profile_business_card.dart';
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final profile = session.profile;
    final displayName =
        sessionDisplayFullName(session, fallback: strings.appName);
    final displayEmail = profile?.email.isNotEmpty == true
        ? profile!.email
        : session.user?.email ?? '';
    final colors = context.ybColors;

    if (session.isLoading) {
      return const YbSkeletonList(count: 2);
    }

    if (!session.isAuthenticated) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context),
        ),
        children: [
          YbSurfaceCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: colors.primaryMuted,
                  child: Icon(
                    YbIcons.person,
                    size: 36,
                    color: context.ybColors.teal,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.profileGuestTitle,
                  style: AppTypography.title.copyWith(color: colors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  strings.profileGuestSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: YbSecondaryButton(
                        label: strings.login,
                        onPressed: () => showAuthBottomSheet(
                          context,
                          ref,
                          initialTab: AuthSheetTab.login,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: YbPrimaryButton(
                        label: strings.register,
                        onPressed: () => showAuthBottomSheet(
                          context,
                          ref,
                          initialTab: AuthSheetTab.register,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          YbProfileMenuSection(
            children: [
              YbProfileMenuTile(
                icon: YbIcons.settings,
                title: strings.settings,
                subtitle: strings.settingsSubtitle,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      );
    }

    return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myXizmatlarProvider);
          ref.invalidate(providerGrowthProvider);
          ref.invalidate(myAchievementsProvider);
        },
        child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context),
        ),
        children: [
          ProfileBusinessCard(
            displayName: displayName,
            email: displayEmail,
            phone: profile?.phone,
            avatarUrl: profile?.avatarUrl,
            userId: session.user?.id,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _ProfileAchievementsSection(),
          if (session.isAuthenticated) ...[
            const SizedBox(height: AppSpacing.lg),
            const _KelishuvSection(),
          ],
          const SizedBox(height: AppSpacing.lg),
          YbProfileMenuSection(
            children: [
              YbProfileMenuTile(
                icon: YbIcons.block,
                title: strings.profileBlocked,
                onTap: () => context.push('/blocked-users'),
              ),
              YbProfileMenuTile(
                icon: YbIcons.settings,
                title: strings.settings,
                subtitle: strings.settingsSubtitle,
                onTap: () => context.push('/settings'),
              ),
              YbProfileMenuTile(
                icon: YbIcons.logoutFilled,
                title: strings.signOut,
                destructive: true,
                onTap: () => ref.read(sessionProvider.notifier).signOut(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Achievements stay folded behind one row (trophy, "1 of 8 unlocked") so
/// the profile stays short; "Show all" opens the full grid.
class _ProfileAchievementsSection extends ConsumerStatefulWidget {
  const _ProfileAchievementsSection();

  @override
  ConsumerState<_ProfileAchievementsSection> createState() =>
      _ProfileAchievementsSectionState();
}

class _ProfileAchievementsSectionState
    extends ConsumerState<_ProfileAchievementsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final achievementsAsync = ref.watch(myAchievementsProvider);

    return YbSurfaceCard(
      child: achievementsAsync.when(
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.achievementsTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            const YbSkeletonBox(width: double.infinity, height: 44),
          ],
        ),
        error: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.achievementsTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.md),
            _ProfileLoadError(
              message: strings.profileSectionLoadFailed,
              retryLabel: strings.actionRetry,
              onRetry: () {
                ref.invalidate(myAchievementsProvider);
                ref.invalidate(providerGrowthProvider);
              },
            ),
          ],
        ),
        data: (unlockedIds) {
          final total = AchievementCatalog.all.length;
          final unlocked = AchievementCatalog.all
              .where((def) => unlockedIds.contains(def.id))
              .length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.tealSoft,
                      borderRadius: BorderRadius.circular(AppRadius.tile),
                    ),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Icon(
                        YbIcons.emojiEvents,
                        size: 22,
                        color: colors.tealInk,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.achievementsTitle,
                          style: AppTypography.headline.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          strings.achievementsProgress(unlocked, total),
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(
                      _expanded
                          ? strings.achievementsHide
                          : strings.achievementsShow,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: AppMotion.of(context, AppMotion.standardDuration),
                curve: AppMotion.standard,
                alignment: Alignment.topCenter,
                child: !_expanded
                    ? const SizedBox(width: double.infinity)
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (unlockedIds.isEmpty) ...[
                              Text(
                                strings.achievementsEmptySub,
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            AchievementsChipGrid(
                              unlockedIds: unlockedIds,
                              strings: strings,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _KelishuvSection extends ConsumerWidget {
  const _KelishuvSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final incomingAsync = ref.watch(incomingKelishuvProvider);
    final requestsAsync = ref.watch(myKelishuvRequestsProvider);

    final incomingCount = incomingAsync.maybeWhen(
      data: (groups) =>
          groups.fold<int>(0, (sum, group) => sum + group.activeCount),
      orElse: () => 0,
    );
    final requestsCount = requestsAsync.maybeWhen(
      data: (items) => items.length,
      orElse: () => 0,
    );

    return YbProfileMenuSection(
      title: strings.kelishuvTitle,
      children: [
        YbProfileMenuTile(
          icon: YbIcons.inbox,
          title: strings.kelishuvIncoming,
          subtitle: strings.kelishuvIncomingSub,
          trailing: incomingCount > 0 ? _CountBadge(count: incomingCount) : null,
          onTap: () => context.push('/kelishuv/incoming'),
        ),
        YbProfileMenuTile(
          icon: YbIcons.send,
          title: strings.kelishuvRequests,
          subtitle: strings.kelishuvRequestsSub,
          trailing: requestsCount > 0 ? _CountBadge(count: requestsCount) : null,
          onTap: () => context.push('/kelishuv/requests'),
        ),
        YbProfileMenuTile(
          icon: YbIcons.archive,
          title: strings.kelishuvArchive,
          subtitle: strings.kelishuvArchiveSub,
          onTap: () => context.push('/kelishuv/archive'),
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.ybColors.primaryMuted,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        '$count',
        style: AppTypography.label.copyWith(color: context.ybColors.teal),
      ),
    );
  }
}

class _ProfileLoadError extends StatelessWidget {
  const _ProfileLoadError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YbInlineMessage(message: message),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(YbIcons.refreshFilled, size: 18),
            label: Text(retryLabel),
          ),
        ),
      ],
    );
  }
}

