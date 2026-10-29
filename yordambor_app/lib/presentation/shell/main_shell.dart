import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/shell/floating_tab_bar.dart';
import 'package:yordambor/presentation/shell/shell_tabs.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  StatefulNavigationShell get navigationShell => widget.navigationShell;

  /// A new tab cross-fades in; the open tab scrolls its page back to the top
  /// (manual N-05). No haptic on tab switches.
  void _onTap(int index) {
    final current = navigationShell.currentIndex;
    if (index == current) ShellTabs.reselect(index);
    navigationShell.goBranch(index, initialLocation: index == current);
  }

  /// Badge counts grow with text no further than the tab labels do (1.3),
  /// so they stay on their icon.
  static Widget _badgeLabel(int count) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Text('$count'),
      );

  /// The five tabs, for the bottom bar and the rail alike.
  List<({Widget icon, Widget selectedIcon, String label})> _tabs(
    AppStrings strings, {
    required int upcomingCount,
    required int pendingCount,
  }) {
    Widget badged(int count, Widget icon) => Badge(
          isLabelVisible: count > 0,
          label: _badgeLabel(count),
          child: icon,
        );
    return [
      (
        icon: const Icon(YbIcons.home),
        selectedIcon: const Icon(YbIcons.homeFilled),
        label: strings.tabHome,
      ),
      (
        icon: const Icon(YbIcons.favorite),
        selectedIcon: const Icon(YbIcons.favoriteFilled),
        label: strings.tabFavorites,
      ),
      (
        icon: badged(upcomingCount, const Icon(YbIcons.calendarMonth)),
        selectedIcon:
            badged(upcomingCount, const Icon(YbIcons.calendarMonthFilled)),
        label: strings.tabCalendar,
      ),
      (
        icon: const Icon(YbIcons.designServices),
        selectedIcon: const Icon(YbIcons.designServicesFilled),
        label: strings.tabBusiness,
      ),
      (
        icon: badged(pendingCount, const Icon(YbIcons.person)),
        selectedIcon: badged(pendingCount, const Icon(YbIcons.personFilled)),
        label: strings.tabProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final pendingAsync = ref.watch(pendingKelishuvActionsProvider);
    final pendingCount =
        pendingAsync.maybeWhen(data: (count) => count, orElse: () => 0);
    final upcomingAsync = ref.watch(upcomingRemindersCountProvider);
    final upcomingCount =
        upcomingAsync.maybeWhen(data: (count) => count, orElse: () => 0);
    final isHome = navigationShell.currentIndex == 0;
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final windowClass = context.windowClass;
    // Tablets, open foldables and phones in landscape: a rail at the side
    // instead of the bar at the bottom.
    final useRail = windowClass.isAtLeastMedium;
    // Home lays out its own list and detail panes on wide windows; other
    // tabs keep a readable column.
    final maxBodyWidth = isHome && windowClass.isAtLeastExpanded
        ? double.infinity
        : AppLayout.maxContentWidth(context);
    final tabs = _tabs(
      strings,
      upcomingCount: upcomingCount,
      pendingCount: pendingCount,
    );

    // No bar here: Home draws its own header and every other tab carries
    // the brand bar inside its page, so the pages cross-fade whole and the
    // layout never jumps between tabs.
    final scaffold = Scaffold(
      extendBody: AppShell.bodyExtendsBehindNav,
      // The same widgets in every layout, so the tabs keep their state when
      // a foldable opens or the phone turns.
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBodyWidth),
          child: SizedBox.expand(child: navigationShell),
        ),
      ),
      // The tab bar floats 12 dp above the gesture area, over the page colour.
      bottomNavigationBar: useRail
          ? null
          : ColoredBox(
              color: colors.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, AppSpacing.xs, 12, 12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isDark ? colors.line : colors.borderSubtle,
                      ),
                      boxShadow: AppElevation.navBar(context),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: Material(
                        color: colors.surfaceElevated,
                        child: FloatingTabBar(
                          selectedIndex: navigationShell.currentIndex,
                          onSelected: _onTap,
                          items: [
                            for (final tab in tabs)
                              FloatingTabItem(
                                icon: tab.icon,
                                selectedIcon: tab.selectedIcon,
                                label: tab.label,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );

    return ColoredBox(
      color: colors.surface,
      child: Row(
        children: [
          if (useRail) ...[
            // Labels grow with text up to 1.3, as on the bottom bar; the
            // rail scrolls when the window is short.
            MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1.3,
              child: NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onTap,
                backgroundColor: colors.surface,
                indicatorColor: colors.tealSoft,
                labelType: NavigationRailLabelType.all,
                groupAlignment: -0.85,
                scrollable: true,
                leading: const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  child: ExcludeSemantics(child: YordamBorLogoMark(size: 36)),
                ),
                destinations: [
                  for (final tab in tabs)
                    NavigationRailDestination(
                      icon: tab.icon,
                      selectedIcon: tab.selectedIcon,
                      label: Text(tab.label),
                    ),
                ],
              ),
            ),
            VerticalDivider(width: 1, thickness: 1, color: colors.line),
          ],
          Expanded(
            key: const ValueKey('shell-body'),
            // The rail already keeps clear of the notch on its side.
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: useRail,
              child: scaffold,
            ),
          ),
        ],
      ),
    );
  }
}
