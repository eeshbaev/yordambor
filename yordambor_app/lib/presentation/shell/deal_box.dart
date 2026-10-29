import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/presentation/kelishuv/widgets/kelishuv_list_tile.dart';

// ── Deal Box Button ───────────────────────────────────────────────────────────

/// AppBar action button that shows a badge with pending deal count
/// and opens the Deal Box bottom sheet on tap.
class DealBoxButton extends ConsumerWidget {
  const DealBoxButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingKelishuvActionsProvider).valueOrNull ?? 0;
    final strings = ref.watch(appStringsProvider);

    return Tooltip(
      message: strings.kelishuvTitle,
      child: IconButton(
        icon: Badge(
          isLabelVisible: pendingCount > 0,
          label: pendingCount > 9
              ? const Text('9+')
              : Text('$pendingCount'),
          child: const Icon(YbIcons.handshake),
        ),
        onPressed: () => _showDealBoxSheet(context, strings),
      ),
    );
  }

  void _showDealBoxSheet(BuildContext context, AppStrings strings) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      sheetAnimationStyle: AppMotion.sheetOf(context),
      builder: (_) => _DealBoxSheet(strings: strings),
    );
  }
}

// ── Deal Box Sheet ────────────────────────────────────────────────────────────

class _DealBoxSheet extends ConsumerWidget {
  const _DealBoxSheet({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;

    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Sheet header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(YbIcons.handshake, color: colors.teal, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  strings.kelishuvTitle,
                  style: AppTypography.title.copyWith(
                    color: colors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // ── Tab bar ────────────────────────────────────────────────────────
          TabBar(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: strings.kelishuvRequests),
              Tab(text: strings.kelishuvIncoming),
              Tab(text: strings.kelishuvArchive),
            ],
          ),
          // ── Tab views ─────────────────────────────────────────────────────
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: TabBarView(
              children: [
                _KelishuvTabBody(
                  strings: strings,
                  items: ref.watch(myKelishuvRequestsProvider).valueOrNull ?? [],
                  emptyLabel: strings.kelishuvRequestsSub,
                ),
                _KelishuvTabBody(
                  strings: strings,
                  items: ref
                          .watch(incomingKelishuvProvider)
                          .valueOrNull
                          ?.expand((g) => g.items)
                          .toList() ??
                      [],
                  emptyLabel: strings.kelishuvIncomingSub,
                ),
                _KelishuvTabBody(
                  strings: strings,
                  items: ref.watch(archivedKelishuvProvider).valueOrNull ?? [],
                  emptyLabel: strings.kelishuvArchiveSub,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab body ──────────────────────────────────────────────────────────────────

class _KelishuvTabBody extends StatelessWidget {
  const _KelishuvTabBody({
    required this.strings,
    required this.items,
    required this.emptyLabel,
  });

  final AppStrings strings;
  final List<KelishuvSummary> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            emptyLabel,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: context.ybColors.ink3),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => KelishuvListTile(item: items[i]),
    );
  }
}
