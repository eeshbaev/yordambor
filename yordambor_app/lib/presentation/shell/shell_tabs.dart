import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/app_motion.dart';

/// A tap on the tab that is already open.
class TabReselect {
  const TabReselect(this.index, this.serial);

  final int index;

  /// Makes every tap a new value, so listeners hear repeated taps.
  final int serial;
}

/// Tab-bar events the tab pages listen to (manual N-05).
abstract final class ShellTabs {
  static final reselected = ValueNotifier<TabReselect?>(null);
  static int _serial = 0;

  static void reselect(int index) =>
      reselected.value = TabReselect(index, ++_serial);

  /// Scrolls [controller] back to the top, with the standard spring, or at
  /// once when motion is reduced.
  static Future<void> scrollToTop(
    BuildContext context,
    ScrollController controller,
  ) async {
    if (!controller.hasClients) return;
    if (AppMotion.reduced(context)) {
      controller.jumpTo(0);
      return;
    }
    await controller.animateTo(
      0,
      duration: AppMotion.emphasised,
      curve: AppMotion.standard,
    );
  }
}

/// Wraps a tab page whose list uses the page's primary scroll controller:
/// tapping its tab again scrolls the list back to the top.
class TabScrollToTop extends StatefulWidget {
  const TabScrollToTop({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<TabScrollToTop> createState() => _TabScrollToTopState();
}

class _TabScrollToTopState extends State<TabScrollToTop> {
  @override
  void initState() {
    super.initState();
    ShellTabs.reselected.addListener(_onReselect);
  }

  @override
  void dispose() {
    ShellTabs.reselected.removeListener(_onReselect);
    super.dispose();
  }

  void _onReselect() {
    final event = ShellTabs.reselected.value;
    if (event == null || event.index != widget.index || !mounted) return;
    final controller = PrimaryScrollController.maybeOf(context);
    if (controller != null) ShellTabs.scrollToTop(context, controller);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
