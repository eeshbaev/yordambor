import 'dart:ui' show DisplayFeatureType;

import 'package:flutter/material.dart';

/// Window size classes, following Android's breakpoints. Layout follows the
/// window, not the device: the same phone can be compact in portrait, a
/// short-height window in landscape and medium when unfolded.
enum WindowClass {
  /// < 600: phones in portrait, half of a split screen.
  compact,

  /// 600–839: unfolded foldables in portrait, small tablets.
  medium,

  /// 840–1199: tablets and foldables in landscape.
  expanded,

  /// 1200–1599: big tablets, desktop windows.
  large,

  /// ≥ 1600.
  xlarge;

  static WindowClass forWidth(double width) {
    if (width < 600) return WindowClass.compact;
    if (width < 840) return WindowClass.medium;
    if (width < 1200) return WindowClass.expanded;
    if (width < 1600) return WindowClass.large;
    return WindowClass.xlarge;
  }

  static WindowClass of(BuildContext context) =>
      forWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == WindowClass.compact;
  bool get isAtLeastMedium => index >= WindowClass.medium.index;
  bool get isAtLeastExpanded => index >= WindowClass.expanded.index;
}

extension WindowClassContext on BuildContext {
  WindowClass get windowClass => WindowClass.of(this);

  /// Phones in landscape: use a rail instead of the bottom bar.
  bool get isShortHeight => MediaQuery.sizeOf(this).height < 480;

  /// The hinge or fold of a foldable, when there is one.
  Rect? get hinge {
    for (final feature in MediaQuery.displayFeaturesOf(this)) {
      if (feature.type != DisplayFeatureType.cutout) return feature.bounds;
    }
    return null;
  }
}

/// Responsive layout helpers for phones, tablets, and foldables.
abstract final class AppLayout {
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 840;
  static const double maxWidthTablet = 560;
  static const double maxWidthDesktop = 720;

  /// Page gutters: 16 on phones, 24 from medium windows up.
  static const double gutterCompact = 16;
  static const double gutterWide = 24;

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
    final horizontal = isWide(context) ? gutterWide : gutterCompact;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }
}
