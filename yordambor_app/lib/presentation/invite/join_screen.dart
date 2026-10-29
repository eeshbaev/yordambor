import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';

/// Where an invite link lands. It says what the invite is for (the trade
/// and city, when the link has them); adding the service is one tap away,
/// and so is looking around first. Nothing here insists.
class JoinScreen extends ConsumerWidget {
  const JoinScreen({super.key, required this.prefill});

  final CreateXizmatPrefill prefill;

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final language = ref.watch(onboardingPrefsProvider).language;
    final colors = context.ybColors;

    // The trade's name, once the categories are loaded.
    String? trade;
    final categories = ref.watch(categoriesProvider).valueOrNull;
    if (categories != null && prefill.categoryId != null) {
      for (final category in categories) {
        if (category.id != prefill.categoryId) continue;
        trade = category.label(language);
        for (final sub in category.subcategories) {
          if (sub.id != prefill.subcategoryId) continue;
          if (prefill.providerType == null ||
              sub.providerType == prefill.providerType) {
            trade = sub.label(language);
          }
        }
      }
    }
    final cityId = prefill.cityId;
    final city = cityId == null ? null : strings.serviceCityLabel(cityId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.actionClose,
          icon: const Icon(YbIcons.closeFilled),
          onPressed: () => _leave(context),
        ),
      ),
      bottomNavigationBar: YbStickyActionBar(
        children: [
          YbPrimaryButton(
            label: strings.feedInviteProvidersAction,
            icon: YbIcons.addBusiness,
            onPressed: () => openCreateXizmat(context, ref, prefill: prefill),
          ),
          const SizedBox(height: AppSpacing.sm),
          YbSecondaryButton(
            label: strings.joinLookAround,
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          const Center(child: YordamBorLogo(size: 96)),
          const SizedBox(height: AppSpacing.xl),
          Text(
            strings.joinTitle,
            textAlign: TextAlign.center,
            style: AppTypography.title.copyWith(color: colors.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.joinBody,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: colors.ink2),
          ),
          if (trade != null || city != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                if (trade != null)
                  YbInfoTag(
                    icon: CategoryIcons.forService(
                      categoryId: prefill.categoryId,
                      subcategoryId: prefill.subcategoryId,
                    ),
                    label: trade,
                    tone: YbInfoTone.service,
                  ),
                if (city != null)
                  YbInfoTag(
                    icon: YbIcons.locationOnFilled,
                    label: city,
                    tone: YbInfoTone.place,
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                colors.star.withValues(alpha: 0.14),
                colors.card,
              ),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    YbIcons.militaryTechFilled,
                    size: 32,
                    color: colors.star,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.foundingBadge,
                          style: AppTypography.headline.copyWith(
                            color: colors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          strings.foundingBadgeNote,
                          style: AppTypography.caption.copyWith(
                            color: colors.ink2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
