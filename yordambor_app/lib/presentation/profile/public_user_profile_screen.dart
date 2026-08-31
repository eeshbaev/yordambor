import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/certificate_providers.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/public_profile_providers.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_job_post_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/widgets/yb_xizmat_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/share/feed_share.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/public_user_profile.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/growth/provider_progress_section.dart';
import 'package:yordambor/presentation/growth/widgets/yb_provider_tier_badge.dart';
import 'package:yordambor/presentation/kelishuv/yordam_bor_flow.dart';
import 'package:yordambor/presentation/profile/widgets/profile_avatar.dart';
import 'package:yordambor/presentation/profile/widgets/profile_certificates_display.dart';

class PublicUserProfileScreen extends ConsumerWidget {
  const PublicUserProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final favorites = ref.watch(favoritesProvider);
    final profileAsync = ref.watch(publicUserProfileProvider(userId));
    final xizmatlarAsync = ref.watch(publicUserXizmatlarProvider(userId));
    final postsAsync = ref.watch(publicUserYordamKerakProvider(userId));
    final certificatesAsync = ref.watch(profileCertificatesProvider(userId));
    final statsAsync = ref.watch(publicProviderStatsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.userProfileTitle),
      ),
      body: profileAsync.when(
        loading: () => const YbSkeletonList(count: 2),
        error: (error, _) => YbEmptyState(
          icon: Icons.error_outline_rounded,
          title: strings.userProfileTitle,
          subtitle: '$error',
        ),
        data: (profile) {
          if (profile == null) {
            return YbEmptyState(
              icon: Icons.person_off_outlined,
              title: strings.userProfileNotFound,
              subtitle: strings.userProfileNotFound,
            );
          }

          final xizmatItems = xizmatlarAsync.maybeWhen(
            data: (items) => items,
            orElse: () => const <XizmatFeedItem>[],
          );

          return ListView(
            padding: EdgeInsets.fromLTRB(
              0,
              AppSpacing.lg,
              0,
              AppSpacing.lg + AppShell.scrollBottomPadding(context),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _ProfileHeader(
                  profile: profile,
                  strings: strings,
                  availabilityLabel: userProfileAvailabilitySummary(
                    xizmatItems,
                    strings,
                  ),
                  tier: statsAsync.valueOrNull?.tier,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: PublicAchievementsRow(profileId: userId),
              ),
              if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    profile.bio!,
                    style: AppTypography.bodyRegular.copyWith(
                      color: context.ybColors.textPrimary,
                    ),
                  ),
                ),
              ],
              certificatesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (certificates) {
                  if (certificates.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.xl,
                      AppSpacing.lg,
                      0,
                    ),
                    child: ProfileCertificatesDisplay(
                      certificates: certificates,
                      strings: strings,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _SectionHeader(title: strings.userProfileServices),
              ),
              const SizedBox(height: AppSpacing.sm),
              xizmatlarAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: YbSkeletonList(count: 1),
                ),
                error: (error, _) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('$error'),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        strings.userProfileServicesEmpty,
                        style: AppTypography.caption.copyWith(
                          color: context.ybColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: items.map((item) {
                      final availability =
                          xizmatAvailabilityDisplay(item, strings);
                      return YbXizmatCard(
                        item: item,
                        isFavorite: favorites.contains(item.id),
                        providerTypeLabel:
                            strings.providerTypeLabel(item.providerType),
                        sectorLine: strings.sectorLine(
                          item.categoryLabel,
                          item.subcategoryLabel,
                        ),
                        completedLabel:
                            strings.xizmatCompletedCount(item.completedCount),
                        priceLabel: xizmatPricingLabel(item, strings),
                        availabilityLabel: availability?.label,
                        availabilityTone: availability?.tone,
                        servicePromise: item.visibleServicePromise,
                        onTap: () => context.push('/xizmat/${item.id}'),
                        onShare: () => FeedShare.shareXizmat(
                          strings: strings,
                          xizmatId: item.id,
                          xizmatName: item.name,
                        ),
                        shareTooltip: strings.shareXizmat,
                        onFavoriteToggle: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(item.id),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _SectionHeader(title: strings.userProfileRequests),
              ),
              const SizedBox(height: AppSpacing.sm),
              postsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: YbSkeletonList(count: 1),
                ),
                error: (error, _) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text('$error'),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        strings.userProfileRequestsEmpty,
                        style: AppTypography.caption.copyWith(
                          color: context.ybColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: items
                        .map(
                          (item) => YbJobPostCard(
                            item: item,
                            sectorLine: strings.sectorLine(
                              item.categoryLabel,
                              item.subcategoryLabel,
                            ),
                            yordamBorLabel: strings.filterYordamBor,
                            onTap: () => context.push('/post/${item.id}'),
                            onShare: () => FeedShare.shareYordamKerakPost(
                              strings: strings,
                              postId: item.id,
                              title: item.title,
                            ),
                            shareTooltip: strings.shareYordamKerak,
                            callLabel: strings.userProfileCall,
                            phoneHiddenLabel: strings.userProfilePhoneHidden,
                            onYordamBor: () async {
                              final allowed = await requireVerifiedAuth(
                                context,
                                ref,
                                authContext: AuthContextType.yordamBor,
                              );
                              if (!allowed || !context.mounted) return;
                              await openYordamBorForPost(
                                context,
                                ref,
                                postId: item.id,
                                subcategoryId: item.subcategoryId,
                              );
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.title.copyWith(
        color: context.ybColors.textPrimary,
        fontSize: 18,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.strings,
    this.availabilityLabel,
    this.tier,
  });

  final PublicUserProfile profile;
  final AppStrings strings;
  final String? availabilityLabel;
  final ProviderTier? tier;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: AppElevation.card(context),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            ProfileAvatar(
              fullName: profile.fullName,
              avatarUrl: profile.avatarUrl,
              radius: 40,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              profile.fullName,
              style: AppTypography.title.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (tier != null) ...[
              const SizedBox(height: AppSpacing.sm),
              YbProviderTierBadge(
                tier: tier!,
                strings: strings,
                compact: true,
              ),
            ],
            if (availabilityLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              YbStatusBadge(
                label: availabilityLabel!,
                tone: availabilityLabel == strings.userProfileBusy
                    ? YbStatusTone.warning
                    : YbStatusTone.success,
              ),
            ],
            if (profile.phone != null && profile.phone!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                strings.userProfilePhoneHidden,
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
