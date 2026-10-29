import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/notification_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/notifications/notification_repository.dart';
import 'package:yordambor/presentation/growth/growth_tips_section.dart';
import 'package:yordambor/presentation/notifications/widgets/deal_activity_section.dart';
import 'package:yordambor/presentation/notifications/widgets/upcoming_appointments_section.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';

/// One list: the coming week's appointments, live deals, today's growth
/// tip, then the news, newest first.
/// Each row opens: a deal, a post or a service, or the full message. The
/// alerts a person set up sit behind the switch icon; alerts made for a
/// service and certificates live inside the service.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final colors = context.ybColors;
    final signedIn = session.user?.id != null;
    final hasDeals = signedIn && ref.watch(dealActivityProvider).isNotEmpty;
    final hasTip = signedIn && GrowthTipsSection.hasTip(ref);
    final hasAppointments = signedIn &&
        UpcomingAppointmentsSection.upcoming(ref).isNotEmpty;

    final List<Widget> news = notificationsAsync.when(
      loading: () => [
        for (var i = 0; i < 3; i++) const YbSkeletonCard(),
      ],
      error: (_, _) => [
        YbEmptyState(
          icon: YbIcons.cloudOff,
          title: strings.stateErrorTitle,
          subtitle: strings.stateErrorBody,
          actionLabel: strings.actionRetry,
          onAction: () => ref.invalidate(notificationsProvider),
        ),
      ],
      data: (items) => items.isEmpty
          // Only "nothing yet" when there is truly nothing on the page.
          ? (hasDeals || hasTip || hasAppointments)
              ? const []
              : [
                  YbEmptyState(
                    icon: YbIcons.notifications,
                    title: strings.notificationsEmpty,
                    subtitle: strings.notificationsEmptySub,
                  ),
                ]
          : _notificationTiles(
              context: context,
              ref: ref,
              strings: strings,
              colors: colors,
              items: items,
            ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.notificationsTitle),
        actions: [
          if (signedIn)
            IconButton(
              tooltip: strings.notificationAlertsTitle,
              onPressed: () => context.push('/notifications/alerts'),
              icon: const Icon(YbIcons.tune),
            ),
        ],
      ),
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(notificationsProvider);
            ref.invalidate(unreadNotificationsCountProvider);
            ref.invalidate(incomingKelishuvProvider);
            ref.invalidate(myKelishuvRequestsProvider);
            ref.invalidate(myAppointmentsProvider);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              if (signedIn) ...[
                const UpcomingAppointmentsSection(),
                const DealActivitySection(),
                const GrowthTipsSection(),
                if (hasTip)
                  Divider(
                    height: 1,
                    color: colors.borderSubtle,
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
              ],
              ...news,
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _notificationTiles({
    required BuildContext context,
    required WidgetRef ref,
    required AppStrings strings,
    required YbThemeColors colors,
    required List<AppNotification> items,
  }) {
    return [
      for (var i = 0; i < items.length; i++) ...[
        if (i > 0)
          Divider(
            height: 1,
            color: colors.borderSubtle,
            indent: AppSpacing.lg,
            endIndent: AppSpacing.lg,
          ),
        _NotificationTile(
          item: items[i],
          strings: strings,
          colors: colors,
          onTap: () => _onNotificationTap(context, ref, strings, items[i]),
        ),
      ],
    ];
  }

  Future<void> _onNotificationTap(
    BuildContext context,
    WidgetRef ref,
    AppStrings strings,
    AppNotification item,
  ) async {
    if (!item.read) {
      await ref.read(notificationRepositoryProvider).markRead(item.id);
      ref.invalidate(notificationsProvider);
      ref.invalidate(unreadNotificationsCountProvider);
    }
    if (!context.mounted) return;

    final kelishuvId = item.payload?['kelishuv_id'] as String?;
    final xizmatId = item.payload?['xizmat_id'] as String?;
    final postId = item.payload?['post_id'] as String?;
    if (kelishuvId != null) {
      await context.push('/kelishuv/$kelishuvId');
    } else if (postId != null) {
      await context.push('/post/$postId');
    } else if (xizmatId != null) {
      await context.push('/xizmat/$xizmatId');
    } else {
      // Nothing to go to: the whole message, in a sheet.
      await showModalBottomSheet<void>(
        context: context,
        sheetAnimationStyle: AppMotion.sheetOf(context),
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (sheetContext) => YbSheetBody(
          title: item.title ?? strings.notificationTypeTitle(item.type),
          children: [
            if (item.body != null)
              Text(
                item.body!,
                style: AppTypography.bodyRegular.copyWith(
                  color: sheetContext.ybColors.textPrimary,
                  height: 1.45,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            YbSecondaryButton(
              label: strings.actionClose,
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.strings,
    required this.colors,
    required this.onTap,
  });

  final AppNotification item;
  final AppStrings strings;
  final YbThemeColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        backgroundColor:
            item.read ? colors.surface : colors.primaryMuted,
        child: Icon(
          _iconForType(item.type),
          color: context.ybColors.teal,
          size: 20,
        ),
      ),
      title: Text(
        item.title ?? strings.notificationTypeTitle(item.type),
        style: (item.read
                ? AppTypography.body.copyWith(color: context.ybColors.textPrimary)
                : AppTypography.body.copyWith(color: context.ybColors.textPrimary, fontWeight: FontWeight.w600))
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
      onTap: onTap,
    );
  }

  IconData _iconForType(String type) => switch (type) {
        'kelishuv_accept' => YbIcons.handshake,
        'kelishuv_message' => YbIcons.chatBubble,
        'kelishuv_complete' => YbIcons.taskAlt,
        'subsector_new_service' => YbIcons.designServices,
        'subsector_discount' => YbIcons.localOffer,
        'subsector_help_post' => YbIcons.campaign,
        _ => YbIcons.notifications,
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
