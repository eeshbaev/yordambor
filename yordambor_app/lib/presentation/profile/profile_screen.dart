import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/certificate_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_profile_menu.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/growth/widgets/achievements_chip_grid.dart';
import 'package:yordambor/presentation/growth/provider_progress_section.dart';
import 'package:yordambor/presentation/profile/widgets/profile_avatar.dart';
import 'package:yordambor/presentation/profile/widgets/profile_certificates_section.dart';
import 'package:yordambor/presentation/profile/widgets/provider_prompt_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final prefs = ref.watch(onboardingPrefsProvider);
    final profile = session.profile;
    final displayName =
        sessionDisplayFullName(session, fallback: strings.appName);
    final displayEmail = profile?.email.isNotEmpty == true
        ? profile!.email
        : session.user?.email ?? '';
    final colors = context.ybColors;

    final showProviderPrompt = session.isAuthenticated &&
        !prefs.providerPromptDismissed;

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
                    Icons.person_outline_rounded,
                    size: 36,
                    color: AppColors.primary,
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
                icon: Icons.settings_outlined,
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
          final userId = ref.read(sessionProvider).user?.id;
          if (userId != null) {
            ref.invalidate(profileCertificatesProvider(userId));
          }
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
          YbSurfaceCard(
            child: Column(
              children: [
                ProfileAvatar(
                  fullName: displayName,
                  avatarUrl: profile?.avatarUrl,
                  editable: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  displayName,
                  style: AppTypography.title.copyWith(color: colors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                if (displayEmail.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    displayEmail,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (profile?.phone.isNotEmpty ?? false) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        profile!.phone,
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                if (session.user?.id != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  YbSecondaryButton(
                    label: strings.profileViewPublic,
                    icon: Icons.visibility_outlined,
                    onPressed: () => context.push('/user/${session.user!.id}'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _ProfileAchievementsSection(),
          if (showProviderPrompt) ...[
            const SizedBox(height: AppSpacing.lg),
            const ProviderPromptCard(),
          ],
          if (session.isAuthenticated) ...[
            const SizedBox(height: AppSpacing.lg),
            const _KelishuvSection(),
            const SizedBox(height: AppSpacing.lg),
            const _ProviderToolsSection(),
            const SizedBox(height: AppSpacing.lg),
            const _MyXizmatlarSection(),
          ],
          const SizedBox(height: AppSpacing.lg),
          YbProfileMenuSection(
            children: [
              YbProfileMenuTile(
                icon: Icons.block_outlined,
                title: strings.profileBlocked,
                onTap: () => context.push('/blocked-users'),
              ),
              YbProfileMenuTile(
                icon: Icons.settings_outlined,
                title: strings.settings,
                subtitle: strings.settingsSubtitle,
                onTap: () => context.push('/settings'),
              ),
              YbProfileMenuTile(
                icon: Icons.logout_rounded,
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

class _ProfileAchievementsSection extends ConsumerWidget {
  const _ProfileAchievementsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const YbSkeletonBox(width: double.infinity, height: 72),
          ],
        ),
        error: (_, __) => Column(
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
        data: (unlockedIds) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              strings.achievementsTitle,
              style: AppTypography.headline.copyWith(color: colors.textPrimary),
            ),
            if (unlockedIds.isEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.achievementsEmptySub,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AchievementsChipGrid(
              unlockedIds: unlockedIds,
              strings: strings,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderToolsSection extends ConsumerWidget {
  const _ProviderToolsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final mineAsync = ref.watch(myXizmatlarProvider);
    final lacksServices = mineAsync.maybeWhen(
      data: (items) => items.isEmpty,
      orElse: () => false,
    );

    return YbProfileMenuSection(
      children: [
        YbProfileMenuTile(
          icon: Icons.menu_book_outlined,
          title: strings.profileClientBook,
          subtitle: strings.profileClientBookSub,
          onTap: () => context.push('/client-book'),
        ),
        YbProfileMenuTile(
          icon: Icons.payments_outlined,
          title: strings.profileEarnings,
          subtitle: lacksServices
              ? strings.createXizmatFirst
              : strings.profileEarningsSub,
          onTap: () => _openProviderTool(
            context,
            ref,
            route: '/earnings',
            lacksServices: lacksServices,
          ),
        ),
        YbProfileMenuTile(
          icon: Icons.alarm_outlined,
          title: strings.remindersTitle,
          subtitle: lacksServices
              ? strings.createXizmatFirst
              : strings.remindersSettingsSubtitle,
          onTap: () => _openProviderTool(
            context,
            ref,
            route: '/reminders',
            lacksServices: lacksServices,
          ),
        ),
      ],
    );
  }

  void _openProviderTool(
    BuildContext context,
    WidgetRef ref, {
    required String route,
    required bool lacksServices,
  }) {
    if (lacksServices) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(appStringsProvider).createXizmatFirst)),
      );
    }
    context.push(route);
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
          icon: Icons.inbox_outlined,
          title: strings.kelishuvIncoming,
          subtitle: strings.kelishuvIncomingSub,
          trailing: incomingCount > 0 ? _CountBadge(count: incomingCount) : null,
          onTap: () => context.push('/kelishuv/incoming'),
        ),
        YbProfileMenuTile(
          icon: Icons.send_outlined,
          title: strings.kelishuvRequests,
          subtitle: strings.kelishuvRequestsSub,
          trailing: requestsCount > 0 ? _CountBadge(count: requestsCount) : null,
          onTap: () => context.push('/kelishuv/requests'),
        ),
        YbProfileMenuTile(
          icon: Icons.archive_outlined,
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
        style: AppTypography.label.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _MyXizmatlarSection extends ConsumerWidget {
  const _MyXizmatlarSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final mineAsync = ref.watch(myXizmatlarProvider);
    final userId = ref.watch(sessionProvider).user?.id;
    final colors = context.ybColors;

    return YbSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.profileMyXizmatlar,
                  style: AppTypography.headline.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _openCreate(context, ref),
                child: Text(strings.createXizmat),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProviderProgressSection(
            embedded: true,
            showAchievements: false,
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(height: 1, color: colors.borderSubtle),
          const SizedBox(height: AppSpacing.sm),
          mineAsync.when(
            loading: () => const _ProfileServicesSkeleton(),
            error: (error, _) => _ProfileLoadError(
              message: strings.profileSectionLoadFailed,
              retryLabel: strings.actionRetry,
              onRetry: () => ref.invalidate(myXizmatlarProvider),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Text(
                  strings.userProfileServicesEmpty,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                );
              }

              return Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: colors.borderSubtle),
                    Builder(
                      builder: (context) {
                        final item = items[i];
                        final availability =
                            xizmatAvailabilityDisplay(item, strings);

                        return InkWell(
                          onTap: () => context.push('/xizmat/${item.id}'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.serviceDisplayName,
                                        style: AppTypography.headline.copyWith(
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        item.subcategoryLabel,
                                        style: AppTypography.caption.copyWith(
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      if (availability != null)
                                        YbStatusBadge(
                                          label: availability.label,
                                          tone: availability.tone,
                                        )
                                      else
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          onPressed: () => context.push(
                                            '/xizmat/${item.id}/manage',
                                          ),
                                          child: Text(
                                            strings.profileSetAvailability,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: colors.textSecondary,
                                  ),
                                  tooltip: strings.xizmatEditTitle,
                                  onPressed: () => context.push(
                                    '/xizmat/${item.id}/manage',
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: colors.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),
          if (userId != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Divider(height: 1, color: colors.borderSubtle),
            const SizedBox(height: AppSpacing.lg),
            ProfileCertificatesSection(profileId: userId, embedded: true),
          ],
        ],
      ),
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final allowed = await requireVerifiedAuth(context, ref);
    if (!allowed || !context.mounted) return;
    context.push('/create-xizmat');
  }
}

class _ProfileServicesSkeleton extends StatelessWidget {
  const _ProfileServicesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          const YbSkeletonBox(width: double.infinity, height: 52),
        ],
      ],
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
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(retryLabel),
          ),
        ),
      ],
    );
  }
}
