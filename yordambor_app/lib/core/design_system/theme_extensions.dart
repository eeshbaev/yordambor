import 'package:flutter/material.dart';

/// Semantic colors that adapt to light/dark while keeping brand teal fixed.
@immutable
class YbThemeColors extends ThemeExtension<YbThemeColors> {
  const YbThemeColors({
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.border,
    required this.borderSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primaryMuted,
    required this.skeleton,
    required this.overlay,
  });

  final Color surface;
  final Color surfaceElevated;
  final Color card;
  final Color border;
  final Color borderSubtle;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primaryMuted;
  final Color skeleton;
  final Color overlay;

  static const light = YbThemeColors(
    surface: Color(0xFFF4F7FA),
    surfaceElevated: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    border: Color(0xFFE2E8F0),
    borderSubtle: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
    primaryMuted: Color(0x1A0D9488),
    skeleton: Color(0xFFE2E8F0),
    overlay: Color(0x660F172A),
  );

  static const dark = YbThemeColors(
    surface: Color(0xFF0B1220),
    surfaceElevated: Color(0xFF111827),
    card: Color(0xFF1E293B),
    border: Color(0xFF334155),
    borderSubtle: Color(0xFF1E293B),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    primaryMuted: Color(0x330D9488),
    skeleton: Color(0xFF334155),
    overlay: Color(0x99000000),
  );

  @override
  YbThemeColors copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? card,
    Color? border,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? primaryMuted,
    Color? skeleton,
    Color? overlay,
  }) {
    return YbThemeColors(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      card: card ?? this.card,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      skeleton: skeleton ?? this.skeleton,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  YbThemeColors lerp(ThemeExtension<YbThemeColors>? other, double t) {
    if (other is! YbThemeColors) return this;
    return YbThemeColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}

extension YbThemeContext on BuildContext {
  YbThemeColors get ybColors =>
      Theme.of(this).extension<YbThemeColors>() ?? YbThemeColors.light;
}
