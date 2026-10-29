import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/growth/growth_program_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/notification_providers.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// The bell in the bar. Its tooltip names it for screen readers; the count
/// (unread news and deals waiting on the person) stays on the icon at any
/// text size.
class ShellNotificationButton extends ConsumerWidget {
  const ShellNotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final unreadAsync = ref.watch(unreadNotificationsCountProvider);
    // Unread news, every deal waiting on this person's reply and new growth
    // tips: the bell counts what needs them.
    final yourTurn = ref.watch(
      dealActivityProvider.select(
        (activity) => activity
            .where((item) => item.kind == DealActivityKind.yourTurn)
            .length,
      ),
    );
    final unreadCount =
        unreadAsync.maybeWhen(data: (count) => count, orElse: () => 0) +
            yourTurn +
            ref.watch(growthUnreadCountProvider);

    return IconButton(
      tooltip: strings.notificationsTooltip,
      icon: Badge(
        isLabelVisible: unreadCount > 0,
        label: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: Text('$unreadCount'),
        ),
        child: const Icon(YbIcons.notifications),
      ),
      onPressed: () => context.push('/notifications'),
    );
  }
}
