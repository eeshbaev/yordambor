import 'package:flutter/material.dart';

/// Responsive layout helpers for phones, tablets, and foldables.
abstract final class AppLayout {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 840;
  static const double maxWidthTablet = 560;
  static const double maxWidthDesktop = 720;

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopBreakpoint) return maxWidthDesktop;
    if (width >= tabletBreakpoint) return maxWidthTablet;
    return width;
  }

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Centers scrollable tab content on large screens.
  static Widget page({
    required BuildContext context,
    required Widget child,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final horizontal = isWide(context) ? 24.0 : 16.0;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }
}
