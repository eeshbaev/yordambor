import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 350);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve spring = Curves.easeOutBack;

  static const double pressScale = 0.98;
}
