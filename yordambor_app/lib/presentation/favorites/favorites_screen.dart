import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_stagger_in.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/shared/xizmat_feed_card.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  /// When the saved list first appeared, so its rows rise in once.
  DateTime? _listShownAt;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final itemsAsync = ref.watch(favoriteXizmatlarProvider);

    if (favoriteIds.isEmpty) {
      return YbEmptyState(
        icon: YbIcons.favorite,
        title: strings.favoritesEmptyTitle,
        subtitle: strings.favoritesEmptySubtitle,
        actionLabel: strings.tabHome,
        onAction: () => context.go('/home'),
      );
    }

    return itemsAsync.when(
      loading: () => const YbSkeletonList(count: 2),
      error: (_, _) => YbEmptyState(
        icon: YbIcons.cloudOff,
        title: strings.stateErrorTitle,
        subtitle: strings.stateErrorBody,
        actionLabel: strings.actionRetry,
        onAction: () => ref.invalidate(favoriteXizmatlarProvider),
      ),
      data: (items) {
        if (items.isEmpty) {
          return YbEmptyState(
            icon: YbIcons.favorite,
            title: strings.favoritesEmptyTitle,
            subtitle: strings.favoritesEmptySubtitle,
            actionLabel: strings.tabHome,
            onAction: () => context.go('/home'),
          );
        }

        final shownAt = _listShownAt ??= DateTime.now();
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppShell.scrollBottomPadding(context),
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return YbStaggerIn(
              key: ValueKey('saved-${item.id}'),
              index: index,
              listShownAt: shownAt,
              child: XizmatFeedCard(item: item),
            );
          },
        );
      },
    );
  }
}
