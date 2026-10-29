import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/receipt_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/business/widgets/business_overview.dart';
import 'package:yordambor/presentation/business/widgets/business_service_card.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';
import 'package:yordambor/presentation/business/provider_tools_section.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';

List<XizmatFeedItem> _ownedInFeed(List<XizmatFeedItem> feedItems, String userId) {
  return feedItems
      .where((item) => item.ownerId == userId && !item.isDemo)
      .toList(growable: false);
}

class MyXizmatlarScreen extends ConsumerStatefulWidget {
  const MyXizmatlarScreen({super.key});

  @override
  ConsumerState<MyXizmatlarScreen> createState() => _MyXizmatlarScreenState();
}

class _MyXizmatlarScreenState extends ConsumerState<MyXizmatlarScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final colors = context.ybColors;

    if (session.isLoading) {
      return const YbSkeletonList(count: 3);
    }

    if (!session.isAuthenticated) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context),
        ),
        children: [
          YbEmptyState(
            icon: YbIcons.storefront,
            title: strings.tabBusiness,
            subtitle: strings.myXizmatlarGuestSubtitle,
            actionLabel: strings.login,
            onAction: () => showAuthBottomSheet(
              context,
              ref,
              initialTab: AuthSheetTab.login,
            ),
          ),
        ],
      );
    }

    final onServicesTab = _tabController.index == 0;
    final mineCount = ref.watch(
      myXizmatlarProvider.select((async) => async.valueOrNull?.length ?? 0),
    );
    final hasServices = mineCount > 0;

    return Scaffold(
      floatingActionButton: onServicesTab && hasServices
          ? FloatingActionButton.extended(
              onPressed: () => _openCreate(context, ref),
              icon: const Icon(YbIcons.addFilled),
              label: Text(strings.createXizmat),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: colors.surfaceElevated,
            child: Column(
              children: [
                TabBar(
              controller: _tabController,
              labelColor: context.ybColors.teal,
              unselectedLabelColor: colors.textTertiary,
              indicatorColor: context.ybColors.teal,
              indicatorWeight: 3,
              labelStyle: AppTypography.label.copyWith(color: context.ybColors.textSecondary, 
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: strings.businessTabServices),
                Tab(text: strings.businessTabTools),
              ],
                ),
                Divider(height: 1, color: colors.borderSubtle),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BusinessServicesTab(onCreate: () => _openCreate(context, ref)),
                const _BusinessToolsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) =>
      openCreateXizmat(context, ref);
}

class _BusinessServicesTab extends ConsumerWidget {
  const _BusinessServicesTab({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final userId = ref.watch(sessionProvider.select((s) => s.user?.id));
    final mineAsync = ref.watch(myXizmatlarProvider);
    final feedOwned = userId == null
        ? const <XizmatFeedItem>[]
        : ref.watch(
            feedProvider.select((feed) => _ownedInFeed(feed.items, userId)),
          );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myXizmatlarProvider);
        ref.invalidate(feedProvider);
        ref.invalidate(providerGrowthProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context) + 72,
        ),
        children: [
          mineAsync.when(
            loading: () => const _ServicesSkeleton(),
            error: (error, _) => _LoadError(
              message: strings.profileSectionLoadFailed,
              retryLabel: strings.actionRetry,
              onRetry: () => ref.invalidate(myXizmatlarProvider),
            ),
            data: (items) {
              final display = items.isNotEmpty ? items : feedOwned;
              // No services yet: encourage the person to add one.
              if (display.isEmpty) {
                return BusinessStartSelling(onCreate: onCreate);
              }

              // Services first, with analytics inside each card.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BusinessServicesHeader(
                    count: display.length,
                    onCreate: onCreate,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final item in display)
                    BusinessServiceCard(item: item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BusinessToolsTab extends ConsumerWidget {
  const _BusinessToolsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myXizmatlarProvider);
        ref.invalidate(receiptToolSubtitleProvider);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppShell.scrollBottomPadding(context),
        ),
        children: [
          Text(
            strings.businessTabTools,
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            strings.businessToolsSubtitle,
            style: AppTypography.bodyRegular.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ProviderToolsSection(),
        ],
      ),
    );
  }
}

class _ServicesSkeleton extends StatelessWidget {
  const _ServicesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        YbSkeletonBox(width: double.infinity, height: 200),
        SizedBox(height: AppSpacing.md),
        YbSkeletonBox(width: double.infinity, height: 200),
      ],
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YbInlineMessage(message: message),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(YbIcons.refreshFilled, size: 18),
            label: Text(retryLabel),
          ),
        ),
      ],
    );
  }
}
