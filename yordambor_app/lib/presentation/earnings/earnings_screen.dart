import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/earnings_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/earnings_row.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final rowsAsync = ref.watch(earningsRowsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.earningsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEarningsSheet(
          context: context,
          ref: ref,
          strings: strings,
        ),
        icon: const Icon(Icons.add),
        label: Text(strings.earningsAdd),
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(earningsRowsProvider),
          child: rowsAsync.when(
            loading: () => const YbSkeletonList(count: 3),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: strings.earningsTitle,
                  subtitle: '$error',
                ),
              ],
            ),
            data: (rows) {
            if (rows.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  YbEmptyState(
                    icon: Icons.payments_outlined,
                    title: strings.earningsEmptyTitle,
                    subtitle: strings.earningsEmptySub,
                  ),
                ],
              );
            }

            final total = rows.fold<double>(0, (sum, row) => sum + row.amount);

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: YbSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.earningsTotal,
                          style: AppTypography.caption.copyWith(
                            color: context.ybColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${total.toStringAsFixed(0)} UZS',
                          style: AppTypography.title.copyWith(
                            color: context.ybColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          strings.earningsDisclaimer,
                          style: AppTypography.caption.copyWith(
                            color: context.ybColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...rows.map(
                  (row) => _EarningsTile(row: row, strings: strings),
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

class _EarningsTile extends ConsumerWidget {
  const _EarningsTile({required this.row, required this.strings});

  final EarningsRow row;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;

    return Dismissible(
      key: ValueKey(row.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await ref.read(earningsRepositoryProvider).deleteRow(row.id);
        ref.invalidate(earningsRowsProvider);
        return true;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          '${row.amount.toStringAsFixed(0)} ${row.currency}',
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        subtitle: Text(
          [
            if (row.xizmatName != null) row.xizmatName,
            _formatDate(row.recordedAt),
            if (row.note != null) row.note,
          ].whereType<String>().join(' · '),
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _showEarningsSheet(
            context: context,
            ref: ref,
            strings: strings,
            row: row,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

Future<void> _showEarningsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  EarningsRow? row,
}) async {
  final isEditing = row != null;
  final amountController = TextEditingController(
    text: isEditing ? row.amount.toStringAsFixed(0) : '',
  );
  final noteController = TextEditingController(text: row?.note ?? '');

  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) {
      return YbSheetBody(
        title: isEditing ? strings.earningsEdit : strings.earningsAdd,
        children: [
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: !isEditing,
            decoration: InputDecoration(
              labelText: strings.earningsAmountLabel,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: strings.earningsNoteLabel,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          YbPrimaryButton(
            label: strings.actionSave,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );

  if (saved != true) return;

  final amount = double.tryParse(amountController.text.trim());
  if (amount == null || amount <= 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.earningsAmountRequired)),
      );
    }
    return;
  }

  final note = noteController.text.trim().isEmpty
      ? null
      : noteController.text.trim();

  final repository = ref.read(earningsRepositoryProvider);
  if (isEditing) {
    await repository.updateRow(
      row.copyWith(amount: amount, note: note),
    );
  } else {
    await repository.createManualRow(amount: amount, note: note);
  }
  ref.invalidate(earningsRowsProvider);
}
