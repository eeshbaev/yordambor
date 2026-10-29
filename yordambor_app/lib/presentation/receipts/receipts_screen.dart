import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/receipt_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/receipt_format.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final receiptsAsync = ref.watch(paymentReceiptsProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.receiptTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/receipts/new'),
        icon: const Icon(YbIcons.addFilled),
        label: Text(strings.receiptNew),
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(paymentReceiptsProvider),
          child: receiptsAsync.when(
            loading: () => const YbSkeletonList(count: 4),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: YbIcons.cloudOff,
                  title: strings.stateErrorTitle,
                  subtitle: strings.stateErrorBody,
                  actionLabel: strings.actionRetry,
                  onAction: () => ref.invalidate(paymentReceiptsProvider),
                ),
              ],
            ),
            data: (receipts) {
              if (receipts.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: YbIcons.receiptLong,
                      title: strings.receiptEmptyTitle,
                      subtitle: strings.receiptEmptySubtitle,
                      actionLabel: strings.receiptNew,
                      onAction: () => context.push('/receipts/new'),
                    ),
                  ],
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: AppShell.scrollBottomPadding(context) + 72,
                ),
                itemCount: receipts.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final receipt = receipts[index];
                  return YbSurfaceCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        receipt.buyerName,
                        style: AppTypography.headline.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${receipt.number} · ${receipt.xizmatName}\n'
                        '${formatReceiptDate(receipt.createdAt)}',
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      trailing: Text(
                        formatReceiptMoney(receipt.total, receipt.currency),
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.ybColors.teal,
                        ),
                      ),
                      onTap: () => context.push('/receipts/${receipt.id}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
