import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/margin_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/margin/widgets/margin_product_card.dart';
import 'package:yordambor/presentation/margin/widgets/margin_sheets.dart';

class MarginScreen extends ConsumerWidget {
  const MarginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final productsAsync = ref.watch(marginProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.marginTitle),
        actions: [
          TextButton(
            onPressed: () => context.push('/margin/units'),
            child: Text(strings.marginOpenUnits),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final id = await showMarginProductSheet(
            context: context,
            ref: ref,
            strings: strings,
          );
          if (id != null && context.mounted) {
            context.push('/margin/product/$id');
          }
        },
        icon: const Icon(YbIcons.addFilled),
        label: Text(strings.marginAddProduct),
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(marginProductsProvider),
          child: productsAsync.when(
            loading: () => const YbSkeletonList(count: 4),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: YbIcons.cloudOff,
                  title: strings.stateErrorTitle,
                  subtitle: strings.stateErrorBody,
                  actionLabel: strings.actionRetry,
                  onAction: () => ref.invalidate(marginProductsProvider),
                ),
              ],
            ),
            data: (products) {
              if (products.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: YbIcons.pieChart,
                      title: strings.marginProductsEmptyTitle,
                      subtitle: strings.marginProductsEmptySub,
                    ),
                  ],
                );
              }

              final avgMargin = products.isEmpty
                  ? 0.0
                  : products
                          .map((p) => p.marginPercent)
                          .reduce((a, b) => a + b) /
                      products.length;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: YbSurfaceCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.marginAvgMargin,
                                  style: AppTypography.caption.copyWith(
                                    color: context.ybColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${avgMargin.toStringAsFixed(0)}%',
                                  style: AppTypography.title.copyWith(
                                    color: context.ybColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${products.length} ${strings.marginPerProduct}',
                            style: AppTypography.caption.copyWith(
                              color: context.ybColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...products.map(
                    (product) => MarginProductCard(
                      product: product,
                      strings: strings,
                      onTap: () => context.push('/margin/product/${product.id}'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
