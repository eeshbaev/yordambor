import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class AppRadius {
  static const double xs = 6;
  static const double chip = 10;
  static const double button = 14;
  static const double card = 16;
  static const double sheet = 20;
  static const double pill = 999;
}

abstract final class AppTouch {
  static const double minTarget = 48;
  static const double buttonHeight = 52;
}

/// Brand colors — fixed across themes.
abstract final class AppColors {
  static const primary = Color(0xFF0D9488);
  static const primaryDark = Color(0xFF0F766E);
  static const primaryLight = Color(0xFF14B8A6);
  static const primaryMuted = Color(0x1A0D9488);
  static const surface = Color(0xFFF4F7FA);
  static const card = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const success = Color(0xFF059669);
  static const warning = Color(0xFFD97706);
  static const error = Color(0xFFDC2626);
  static const border = Color(0xFFE2E8F0);
  static const skeleton = Color(0xFFE2E8F0);
  static const demoBadge = Color(0xFF6366F1);
  static const star = Color(0xFFF59E0B);
}

abstract final class AppShell {
  /// Height of [FloatingActionButton.extended] on the home Yordam Kerak tab.
  static const double extendedFabHeight = 56;

  /// When false, tab body ends above [NavigationBar] so it stays always visible.
  static const bool bodyExtendsBehindNav = false;

  /// Scroll inset for tab screens inside [MainShell].
  static double scrollBottomPadding(
    BuildContext context, {
    bool includeExtendedFab = false,
  }) {
    final fabInset = includeExtendedFab
        ? extendedFabHeight + AppSpacing.lg
        : 0.0;

    if (!bodyExtendsBehindNav) {
      return AppSpacing.xl + fabInset;
    }

    final media = MediaQuery.of(context);
    final systemBottom = media.viewPadding.bottom;
    final navHeight =
        NavigationBarTheme.of(context).height ?? kBottomNavigationBarHeight;
    final shellInset = systemBottom > 0 ? 0.0 : AppSpacing.sm;
    return navHeight + systemBottom + shellInset + AppSpacing.xl + fabInset;
  }

  /// Bottom offset for the home Yordam Kerak FAB.
  static double homeFabBottomOffset(BuildContext context) {
    if (!bodyExtendsBehindNav) {
      return AppSpacing.lg;
    }

    final media = MediaQuery.of(context);
    final systemBottom = media.viewPadding.bottom;
    final navHeight =
        NavigationBarTheme.of(context).height ?? kBottomNavigationBarHeight;
    final shellInset = systemBottom > 0 ? 0.0 : AppSpacing.sm;
    return navHeight + systemBottom + shellInset + AppSpacing.lg;
  }
}

abstract final class AppTypography {
  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required double height,
    Color? color,
    double? letterSpacing,
  }) {
    return AppFonts.manrope(
      size: size,
      weight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle get display => _style(
        size: 32,
        weight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.5,
      );

  static TextStyle get title => _style(
        size: 22,
        weight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.25,
      );

  static TextStyle get headline => _style(
        size: 17,
        weight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get body => _style(
        size: 15,
        weight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get bodyRegular => _style(
        size: 15,
        weight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get caption => _style(
        size: 13,
        weight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => _style(
        size: 12,
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => _style(
        size: 16,
        weight: FontWeight.w700,
        height: 1.2,
        color: Colors.white,
      );
}
