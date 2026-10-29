import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/widgets/yb_undo_snackbar.dart';
import 'package:yordambor/core/design_system/widgets/yb_xizmat_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/founding_providers.dart';
import 'package:yordambor/core/utils/xizmat_availability_display.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';
import 'package:yordambor/presentation/shared/detail_pane.dart';
import 'package:yordambor/presentation/shared/sample_listing_actions.dart';

/// [YbXizmatCard] wired to the app: strings, saved state and navigation.
/// Home, Saqlangan and public profiles show services the same way.
class XizmatFeedCard extends ConsumerWidget {
  const XizmatFeedCard({
    super.key,
    required this.item,
    this.showOwner = true,
  });

  final XizmatFeedItem item;

  /// Off on the owner's own profile, where the name is the page title.
  final bool showOwner;

  /// "Yordam kerak" on the card: the same request as on the service page.
  /// A sample takes no request; it leads to a real one in its trade.
  Future<void> _ask(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
  ) async {
    if (item.isDemo) {
      await findProviderFromSample(context, ref, item);
      return;
    }
    final allowed = await requireVerifiedAuth(
      context,
      ref,
      authContext: AuthContextType.yordamKerak,
    );
    if (!allowed || !context.mounted) return;
    await openTaklifFlow(
      context,
      ref,
      target: TaklifTarget.xizmat(xizmatId: item.id),
      title: strings.taklifFlowTitleYordamKerak(item.name),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final isFavorite =
        ref.watch(favoritesProvider.select((ids) => ids.contains(item.id)));
    final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
    final isOwn = userId != null && item.ownerId == userId;
    final availability = xizmatAvailabilityDisplay(item, strings);
    final city = strings.serviceCityDisplayLabel(item.serviceCity)?.trim();
    final selected = DetailPane.selectedOf(context) ==
        (kind: DetailKind.xizmat, id: item.id);
    final trade = item.subcategoryLabel.trim().isNotEmpty
        ? item.subcategoryLabel
        : item.categoryLabel;

    // Organisation or person shows as a mark on the photo, not as words.
    final providerLine =
        showOwner && item.showsOwnerNameLine ? item.displayOwnerName : null;

    return YbXizmatCard(
      item: item,
      isFavorite: isFavorite,
      categoryLabel: trade,
      cityLabel: city != null && city.isNotEmpty ? city : null,
      sampleLabel: item.isDemo ? strings.sampleTag : null,
      foundingLabel:
          FoundingProviders.isFounding(item) ? strings.foundingBadge : null,
      askLabel: isOwn ? null : strings.filterYordamKerak,
      onAsk: isOwn ? null : () => _ask(context, ref, strings),
      completedLabel: strings.xizmatCompletedCount(item.completedCount),
      newLabel: strings.xizmatCardNew,
      saveTooltip: strings.favoriteAdd,
      unsaveTooltip: strings.favoriteRemove,
      priceLabel: xizmatPricingLabel(item, strings),
      availabilityLabel: availability?.label,
      availabilityTone: availability?.tone,
      providerLine: providerLine,
      providerTypeLabel: strings.providerTypeLabel(item.providerType),
      ratingSemantics: strings.a11yRating,
      newSemantics: strings.a11yNewProvider,
      selected: selected,
      onTap: () => openXizmat(context, item.id),
      onOwnerTap: showOwner && item.ownerId != null
          ? () => context.push('/user/${item.ownerId}')
          : null,
      onFavoriteToggle: () async {
        final favorites = ref.read(favoritesProvider.notifier);
        final messenger = ScaffoldMessenger.of(context);
        final saved = await favorites.toggle(item.id);
        if (!saved) {
          showYbUndoSnackBar(
            messenger,
            message: strings.savedRemoved,
            undoLabel: strings.actionUndo,
            onUndo: () => favorites.toggle(item.id),
          );
        }
        return saved;
      },
    );
  }
}
