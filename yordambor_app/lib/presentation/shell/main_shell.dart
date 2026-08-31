import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/shell/shell_notification_button.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final pendingAsync = ref.watch(pendingKelishuvActionsProvider);
    final pendingCount =
        pendingAsync.maybeWhen(data: (count) => count, orElse: () => 0);
    final isHome = navigationShell.currentIndex == 0;
    final colors = context.ybColors;

    return Scaffold(
      extendBody: AppShell.bodyExtendsBehindNav,
      appBar: isHome
          ? null
          : AppBar(
              title: YbAppBrandTitle(
                style: AppTypography.title.copyWith(color: colors.textPrimary),
              ),
              actions: const [ShellNotificationButton()],
            ),
      body: AppLayout.page(
        context: context,
        child: SizedBox.expand(child: navigationShell),
      ),
      bottomNavigationBar: ColoredBox(
        color: colors.surfaceElevated,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.sheet),
              border: Border.all(color: colors.border),
              boxShadow: AppElevation.navBar(context),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sheet),
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onTap,
                elevation: 0,
                height: 68,
                backgroundColor: colors.surfaceElevated,
                indicatorColor: colors.primaryMuted,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home_rounded),
                    label: strings.tabHome,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.favorite_outline_rounded),
                    selectedIcon: const Icon(Icons.favorite_rounded),
                    label: strings.tabFavorites,
                  ),
                  NavigationDestination(
                    icon: Badge(
                      isLabelVisible: pendingCount > 0,
                      label: Text('$pendingCount'),
                      child: const Icon(Icons.person_outline_rounded),
                    ),
                    selectedIcon: Badge(
                      isLabelVisible: pendingCount > 0,
                      label: Text('$pendingCount'),
                      child: const Icon(Icons.person_rounded),
                    ),
                    label: strings.tabProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
