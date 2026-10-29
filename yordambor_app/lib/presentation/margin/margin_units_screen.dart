import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/margin_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/margin_unit.dart';
import 'package:yordambor/presentation/margin/widgets/margin_unit_sheet.dart';
import 'package:yordambor/core/utils/money_format.dart';

class MarginUnitsScreen extends ConsumerWidget {
  const MarginUnitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final unitsAsync = ref.watch(marginUnitsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.marginUnitsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showMarginUnitSheet(
          context: context,
          ref: ref,
          strings: strings,
        ),
        icon: const Icon(YbIcons.addFilled),
        label: Text(strings.marginAddUnit),
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(marginUnitsProvider),
          child: unitsAsync.when(
            loading: () => const YbSkeletonList(count: 4),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: YbIcons.cloudOff,
                  title: strings.stateErrorTitle,
                  subtitle: strings.stateErrorBody,
                  actionLabel: strings.actionRetry,
                  onAction: () => ref.invalidate(marginUnitsProvider),
                ),
              ],
            ),
            data: (units) {
              if (units.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: YbIcons.straighten,
                      title: strings.marginUnitsEmptyTitle,
                      subtitle: strings.marginUnitsEmptySub,
                    ),
                  ],
                );
              }

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      strings.marginUnitsSubtitle,
                      style: AppTypography.caption.copyWith(
                        color: context.ybColors.textSecondary,
                      ),
                    ),
                  ),
                  ...units.map(
                    (unit) => _MarginUnitTile(unit: unit, strings: strings),
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

class _MarginUnitTile extends ConsumerWidget {
  const _MarginUnitTile({required this.unit, required this.strings});

  final MarginUnit unit;
  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final subtitle = [
      formatMoney(
        unit.unitCostUzs,
        'UZS',
        languageCode: strings.languageCode,
      ),
      if (unit.basisLabel != null && unit.basisLabel!.isNotEmpty)
        unit.basisLabel,
    ].join(' · ');

    return Dismissible(
      key: ValueKey(unit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: context.ybColors.error,
        child: const Icon(YbIcons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        await ref.read(marginUnitsRepositoryProvider).delete(unit.id);
        ref.invalidate(marginUnitsProvider);
        return true;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          unit.name,
          style: AppTypography.headline.copyWith(color: colors.textPrimary),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
        trailing: IconButton(
          tooltip: strings.marginEditUnit,
          icon: const Icon(YbIcons.edit),
          onPressed: () => showMarginUnitSheet(
            context: context,
            ref: ref,
            strings: strings,
            unit: unit,
          ),
        ),
      ),
    );
  }
}
