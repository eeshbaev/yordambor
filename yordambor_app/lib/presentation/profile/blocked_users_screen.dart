import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/safety/block_repository.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final blockedAsync = ref.watch(blockedUsersProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.profileBlocked)),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(blockedUsersProvider);
            ref.invalidate(blockedUserIdsProvider);
          },
          child: blockedAsync.when(
            loading: () => const YbSkeletonList(count: 3),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: strings.profileBlocked,
                  subtitle: '$error',
                ),
              ],
            ),
            data: (users) {
              if (users.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: Icons.block_outlined,
                      title: strings.profileBlocked,
                      subtitle: strings.safetyHideUser,
                    ),
                  ],
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.borderSubtle,
                ),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    title: Text(
                      user.fullName,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(user.blockedAt),
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () =>
                          _unblock(context, ref, user.userId, strings),
                      child: Text(strings.actionUnblock),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _unblock(
    BuildContext context,
    WidgetRef ref,
    String userId,
    AppStrings strings,
  ) async {
    try {
      await ref.read(blockRepositoryProvider).unblockUser(userId);
      ref.invalidate(blockedUsersProvider);
      ref.invalidate(blockedUserIdsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.blockedUnblocked)),
        );
      }
    } on BlockFailure catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }
}
