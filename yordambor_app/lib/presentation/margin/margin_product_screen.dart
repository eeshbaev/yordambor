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
import 'package:yordambor/core/design_system/widgets/yb_undo_snackbar.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/margin_product.dart';
import 'package:yordambor/presentation/margin/widgets/margin_sheets.dart';
import 'package:yordambor/presentation/margin/widgets/margin_summary_card.dart';

class MarginProductScreen extends ConsumerWidget {
  const MarginProductScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final productAsync = ref.watch(marginProductProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: productAsync.maybeWhen(
          data: (product) => Text(product?.name ?? strings.marginTitle),
          orElse: () => Text(strings.marginTitle),
        ),
        actions: [
          productAsync.maybeWhen(
            data: (product) {
              if (product == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: strings.marginEditProduct,
                icon: const Icon(YbIcons.edit),
                onPressed: () => showMarginProductSheet(
                  context: context,
                  ref: ref,
                  strings: strings,
                  product: product,
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: productAsync.maybeWhen(
        data: (product) {
          if (product == null) return null;
          return FloatingActionButton.extended(
            onPressed: () => showMarginLineSheet(
              context: context,
              ref: ref,
              strings: strings,
              product: product,
            ),
            icon: const Icon(YbIcons.addFilled),
            label: Text(strings.marginAddLine),
          );
        },
        orElse: () => null,
      ),
      body: AppLayout.page(
        context: context,
        child: productAsync.when(
          loading: () => const YbSkeletonList(count: 3),
          error: (error, _) => YbEmptyState(
            icon: YbIcons.cloudOff,
            title: strings.stateErrorTitle,
            subtitle: strings.stateErrorBody,
            actionLabel: strings.actionRetry,
            onAction: () => ref.invalidate(marginProductProvider(productId)),
          ),
          data: (product) {
            if (product == null) {
              return YbEmptyState(
                icon: YbIcons.searchOff,
                title: strings.marginProductsEmptyTitle,
                subtitle: strings.marginProductsEmptySub,
              );
            }
            return _ProductBody(
              product: product,
              strings: strings,
              productId: productId,
            );
          },
        ),
      ),
    );
  }
}

class _ProductBody extends ConsumerWidget {
  const _ProductBody({
    required this.product,
    required this.strings,
    required this.productId,
  });

  final MarginProduct product;
  final AppStrings strings;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;

    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: MarginSummaryCard(product: product, strings: strings),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            strings.marginCostBreakdown,
            style: AppTypography.label.copyWith(color: colors.textPrimary),
          ),
        ),
        if (product.lines.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              strings.marginProductsEmptySub,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          )
        else
          ...product.lines.map(
            (line) => Dismissible(
              key: ValueKey(line.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                color: context.ybColors.error,
                child: const Icon(YbIcons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                final lines = product.lines.where((l) => l.id != line.id).toList();
                await ref.read(marginProductsRepositoryProvider).save(
                      product.copyWith(lines: lines),
                    );
                ref.invalidate(marginProductsProvider);
                ref.invalidate(marginProductProvider(productId));
                return true;
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                title: Text(
                  line.name,
                  style: AppTypography.headline.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  formatMarginLineSubtitle(line, strings),
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                trailing: Text(
                  formatMarginUzs(line.lineCostUzs),
                  style: AppTypography.label.copyWith(color: colors.textPrimary),
                ),
                onTap: () => showMarginLineSheet(
                  context: context,
                  ref: ref,
                  strings: strings,
                  product: product,
                  line: line,
                ),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: TextButton.icon(
            // Deletes at once and offers an undo (manual S-04).
            onPressed: () async {
              final repository = ref.read(marginProductsRepositoryProvider);
              final messenger = ScaffoldMessenger.of(context);
              final container = ProviderScope.containerOf(context);
              await repository.delete(product.id);
              container.invalidate(marginProductsProvider);
              showYbUndoSnackBar(
                messenger,
                message: strings.undoDeleted,
                undoLabel: strings.actionUndo,
                onUndo: () async {
                  await repository.save(product);
                  container.invalidate(marginProductsProvider);
                },
              );
              if (context.mounted) context.pop();
            },
            icon: Icon(YbIcons.delete, color: context.ybColors.error),
            label: Text(
              strings.marginDeleteProduct,
              style: TextStyle(color: context.ybColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
