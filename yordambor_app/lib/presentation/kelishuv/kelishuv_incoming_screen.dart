import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_load_error_retry.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/presentation/kelishuv/widgets/kelishuv_list_tile.dart';

class KelishuvIncomingScreen extends ConsumerWidget {
  const KelishuvIncomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final inboxAsync = ref.watch(incomingKelishuvProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.kelishuvIncoming)),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(incomingKelishuvProvider),
          child: inboxAsync.when(
          loading: () => const YbSkeletonList(count: 4),
          error: (_, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              YbLoadErrorRetry(
                message: strings.profileSectionLoadFailed,
                retryLabel: strings.actionRetry,
                onRetry: () => ref.invalidate(incomingKelishuvProvider),
              ),
            ],
          ),
          data: (groups) {
            if (groups.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  YbEmptyState(
                    icon: Icons.inbox_outlined,
                    title: strings.kelishuvIncoming,
                    subtitle: strings.kelishuvIncomingSub,
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final colors = context.ybColors;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () => context.push(
                        '/kelishuv/incoming/${group.xizmatId}',
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                group.xizmatName,
                                style: AppTypography.headline.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryMuted,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                '${group.activeCount}',
                                style: AppTypography.label.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...group.items.take(2).map(
                          (item) => KelishuvListTile(
                            item: item,
                            subtitle: group.xizmatName,
                          ),
                        ),
                    if (group.items.length > 2)
                      TextButton(
                        onPressed: () => context.push(
                          '/kelishuv/incoming/${group.xizmatId}',
                        ),
                        child: Text(strings.kelishuvMoreCount(group.items.length - 2)),
                      ),
                    const Divider(height: AppSpacing.xl),
                  ],
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

class KelishuvXizmatInboxScreen extends ConsumerWidget {
  const KelishuvXizmatInboxScreen({
    super.key,
    required this.xizmatId,
    this.xizmatName,
  });

  final String xizmatId;
  final String? xizmatName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final itemsAsync = ref.watch(kelishuvInboxForXizmatProvider(xizmatId));

    return Scaffold(
      appBar: AppBar(title: Text(xizmatName ?? strings.kelishuvIncoming)),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(kelishuvInboxForXizmatProvider(xizmatId)),
          child: itemsAsync.when(
          loading: () => const YbSkeletonList(count: 4),
          error: (_, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              YbLoadErrorRetry(
                message: strings.profileSectionLoadFailed,
                retryLabel: strings.actionRetry,
                onRetry: () =>
                    ref.invalidate(kelishuvInboxForXizmatProvider(xizmatId)),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  YbEmptyState(
                    icon: Icons.inbox_outlined,
                    title: strings.kelishuvIncoming,
                    subtitle: strings.kelishuvIncomingSub,
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return KelishuvListTile(item: items[index]);
              },
            );
          },
        ),
        ),
      ),
    );
  }
}
