import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/notification_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.notificationsTitle)),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(notificationsProvider),
          child: notificationsAsync.when(
            loading: () => const YbSkeletonList(count: 4),
            error: (error, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                YbEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: strings.notificationsTitle,
                  subtitle: '$error',
                ),
              ],
            ),
            data: (items) {
              if (items.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    YbEmptyState(
                      icon: Icons.notifications_none_outlined,
                      title: strings.notificationsEmpty,
                      subtitle: strings.notificationsEmptySub,
                    ),
                  ],
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.borderSubtle,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final kelishuvId = item.payload?['kelishuv_id'] as String?;
                  final xizmatId = item.payload?['xizmat_id'] as String?;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: item.read
                          ? colors.surface
                          : colors.primaryMuted,
                      child: Icon(
                        _iconForType(item.type),
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.title ?? strings.notificationTypeTitle(item.type),
                      style: (item.read
                              ? AppTypography.body
                              : AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ))
                          .copyWith(color: colors.textPrimary),
                    ),
                    subtitle: item.body != null
                        ? Text(
                            item.body!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          )
                        : null,
                    trailing: Text(
                      _formatTime(strings, item.createdAt),
                      style: AppTypography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                    onTap: () async {
                      if (!item.read) {
                        await ref
                            .read(notificationRepositoryProvider)
                            .markRead(item.id);
                        ref.invalidate(notificationsProvider);
                        ref.invalidate(unreadNotificationsCountProvider);
                      }
                      if (kelishuvId != null && context.mounted) {
                        context.push('/kelishuv/$kelishuvId');
                      } else if (xizmatId != null && context.mounted) {
                        context.push('/xizmat/$xizmatId');
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) => switch (type) {
        'kelishuv_accept' => Icons.handshake_outlined,
        'kelishuv_message' => Icons.chat_bubble_outline,
        'kelishuv_complete' => Icons.task_alt_outlined,
        _ => Icons.notifications_outlined,
      };

  String _formatTime(AppStrings strings, DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) {
      return strings.notificationTimeMinutes(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return strings.notificationTimeHours(diff.inHours);
    }
    return strings.notificationTimeDate(time.day, time.month);
  }
}
