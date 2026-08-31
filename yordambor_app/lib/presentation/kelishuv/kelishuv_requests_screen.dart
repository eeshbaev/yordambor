import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_load_error_retry.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/presentation/kelishuv/widgets/kelishuv_list_tile.dart';

class KelishuvRequestsScreen extends ConsumerWidget {
  const KelishuvRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final requestsAsync = ref.watch(myKelishuvRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.kelishuvRequests)),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(myKelishuvRequestsProvider),
          child: requestsAsync.when(
          loading: () => const YbSkeletonList(count: 4),
          error: (_, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              YbLoadErrorRetry(
                message: strings.profileSectionLoadFailed,
                retryLabel: strings.actionRetry,
                onRetry: () => ref.invalidate(myKelishuvRequestsProvider),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  YbEmptyState(
                    icon: Icons.send_outlined,
                    title: strings.kelishuvRequests,
                    subtitle: strings.kelishuvRequestsSub,
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
