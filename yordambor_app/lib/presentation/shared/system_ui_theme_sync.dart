import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keeps status bar and navigation bar icons readable in light and dark mode.
class SystemUiThemeSync extends StatelessWidget {
  const SystemUiThemeSync({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final overlay = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );

    SystemChrome.setSystemUIOverlayStyle(overlay);

    return child;
  }
}
