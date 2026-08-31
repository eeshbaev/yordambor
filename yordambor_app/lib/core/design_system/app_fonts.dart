import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';

abstract final class AppFonts {
  static const family = 'Manrope';

  static TextStyle manrope({
    required double size,
    required FontWeight weight,
    required double height,
    Color? color,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color ?? AppColors.textPrimary,
    );
  }
}
