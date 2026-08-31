import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_xizmat_card.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/core/share/feed_share.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final itemsAsync = ref.watch(favoriteXizmatlarProvider);

    if (favoriteIds.isEmpty) {
      return YbEmptyState(
        icon: Icons.favorite_outline,
        title: strings.favoritesEmptyTitle,
        subtitle: strings.favoritesEmptySubtitle,
        actionLabel: strings.tabHome,
        onAction: () => context.go('/home'),
      );
    }

    return itemsAsync.when(
      loading: () => const YbSkeletonList(count: 2),
      error: (error, _) => YbEmptyState(
        icon: Icons.error_outline_rounded,
        title: strings.tabFavorites,
        subtitle: '$error',
      ),
      data: (items) {
        if (items.isEmpty) {
          return YbEmptyState(
            icon: Icons.favorite_outline,
            title: strings.favoritesEmptyTitle,
            subtitle: strings.favoritesEmptySubtitle,
            actionLabel: strings.tabHome,
            onAction: () => context.go('/home'),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppShell.scrollBottomPadding(context),
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final availability = xizmatAvailabilityDisplay(item, strings);
            return YbXizmatCard(
              item: item,
              isFavorite: true,
              providerTypeLabel: strings.providerTypeLabel(item.providerType),
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
              onOwnerTap: item.ownerId != null
                  ? () => context.push('/user/${item.ownerId}')
                  : null,
              onFavoriteToggle: () =>
                  ref.read(favoritesProvider.notifier).toggle(item.id),
            );
          },
        );
      },
    );
  }
}
