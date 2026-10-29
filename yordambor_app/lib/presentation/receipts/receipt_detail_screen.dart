import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/receipt_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_undo_snackbar.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/utils/receipt_format.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/receipts/receipt_pdf_builder.dart';
import 'package:yordambor/domain/entities/payment_receipt.dart';

class ReceiptDetailScreen extends ConsumerWidget {
  const ReceiptDetailScreen({super.key, required this.receiptId});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final receiptAsync = ref.watch(paymentReceiptProvider(receiptId));
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.receiptTitle),
        actions: [
          IconButton(
            tooltip: strings.actionDelete,
            icon: const Icon(YbIcons.delete),
            onPressed: () => _delete(context, ref, strings),
          ),
        ],
      ),
      body: AppLayout.page(
        context: context,
        child: receiptAsync.when(
          loading: () => const YbSkeletonList(count: 2),
          error: (_, _) => YbEmptyState(
            icon: YbIcons.cloudOff,
            title: strings.stateErrorTitle,
            subtitle: strings.stateErrorBody,
            actionLabel: strings.actionRetry,
            onAction: () => ref.invalidate(paymentReceiptProvider(receiptId)),
          ),
          data: (receipt) {
            if (receipt == null) {
              return Center(child: Text(strings.xizmatNotFound));
            }

            return ListView(
              padding: EdgeInsets.only(
                bottom: AppShell.scrollBottomPadding(context),
              ),
              children: [
                YbSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        receipt.number,
                        style: AppTypography.title.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        formatReceiptDate(receipt.createdAt),
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        '${strings.receiptBuyer}: ${receipt.buyerName}',
                        style: AppTypography.body.copyWith(color: context.ybColors.textPrimary),
                      ),
                      if (receipt.buyerPhone.isNotEmpty)
                        Text(
                          receipt.buyerPhone,
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${strings.receiptXizmat}: ${receipt.xizmatName}',
                        style: AppTypography.body.copyWith(color: context.ybColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      for (final line in receipt.lines) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(line.title)),
                            Text(
                              formatReceiptMoney(
                                line.lineTotal,
                                receipt.currency,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                      ],
                      const Divider(),
                      _row(
                        strings.receiptTotal,
                        formatReceiptMoney(receipt.total, receipt.currency),
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                YbPrimaryButton(
                  label: strings.receiptSharePdf,
                  icon: YbIcons.iosShareFilled,
                  onPressed: () => _sharePdf(context, ref, receipt),
                ),
                const SizedBox(height: AppSpacing.sm),
                YbSecondaryButton(
                  label: strings.receiptPreview,
                  icon: YbIcons.pictureAsPdf,
                  onPressed: () => _previewPdf(context, ref, receipt),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: bold ? FontWeight.w700 : null),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: bold ? FontWeight.w700 : null),
        ),
      ],
    );
  }

  Future<void> _sharePdf(
    BuildContext context,
    WidgetRef ref,
    PaymentReceipt receipt,
  ) async {
    final strings = ref.read(appStringsProvider);
    final bytes = await ReceiptPdfBuilder.build(receipt, strings);
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${receipt.number}.pdf',
    );
  }

  Future<void> _previewPdf(
    BuildContext context,
    WidgetRef ref,
    PaymentReceipt receipt,
  ) async {
    final strings = ref.read(appStringsProvider);
    await Printing.layoutPdf(
      onLayout: (_) => ReceiptPdfBuilder.build(receipt, strings),
    );
  }

  /// Deletes at once and offers an undo (manual S-04): a receipt lives on
  /// this phone, so it can simply be put back.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
  ) async {
    final repository = ref.read(paymentReceiptsRepositoryProvider);
    final receipt = await repository.fetchById(receiptId);
    if (receipt == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final container = ProviderScope.containerOf(context);
    await repository.delete(receiptId);
    container.invalidate(paymentReceiptsProvider);
    showYbUndoSnackBar(
      messenger,
      message: strings.undoDeleted,
      undoLabel: strings.actionUndo,
      onUndo: () async {
        await repository.save(receipt);
        container.invalidate(paymentReceiptsProvider);
        container.invalidate(paymentReceiptProvider(receiptId));
      },
    );
    if (context.mounted) context.pop();
  }
}
