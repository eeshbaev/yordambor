import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_load_error_retry.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/presentation/kelishuv/widgets/kelishuv_list_tile.dart';

/// Closed deals in two lists: the help the person asked for and the help
/// they gave, so each is easy to find again.
class KelishuvArchiveScreen extends ConsumerWidget {
  const KelishuvArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.kelishuvArchive),
          bottom: TabBar(
            labelColor: colors.teal,
            unselectedLabelColor: colors.textTertiary,
            indicatorColor: colors.teal,
            indicatorWeight: 3,
            labelStyle: AppTypography.label.copyWith(
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              Tab(text: strings.archiveTabNeeded),
              Tab(text: strings.archiveTabProvided),
            ],
          ),
        ),
        body: AppLayout.page(
          context: context,
          child: TabBarView(
            children: [
              _ArchiveList(
                provided: false,
                emptyIcon: YbIcons.campaign,
                emptySubtitle: strings.archiveNeededEmpty,
              ),
              _ArchiveList(
                provided: true,
                emptyIcon: YbIcons.handshake,
                emptySubtitle: strings.archiveProvidedEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveList extends ConsumerWidget {
  const _ArchiveList({
    required this.provided,
    required this.emptyIcon,
    required this.emptySubtitle,
  });

  /// The help the person gave (else the help they asked for).
  final bool provided;
  final IconData emptyIcon;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final archiveAsync = ref.watch(archivedKelishuvProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(archivedKelishuvProvider),
      child: archiveAsync.when(
        loading: () => const YbSkeletonList(count: 4),
        error: (_, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            YbLoadErrorRetry(
              message: strings.profileSectionLoadFailed,
              retryLabel: strings.actionRetry,
              onRetry: () => ref.invalidate(archivedKelishuvProvider),
            ),
          ],
        ),
        data: (all) {
          final List<KelishuvSummary> items =
              all.where((item) => item.iProvide == provided).toList();
          if (items.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: emptyIcon,
                  title: strings.kelishuvArchiveEmptyTitle,
                  subtitle: emptySubtitle,
                ),
              ],
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return KelishuvListTile(
                item: item,
                subtitle: item.xizmatName,
                // Booking again fits the help the person asked for.
                showRepeatBook: !provided,
              );
            },
          );
        },
      ),
    );
  }
}
