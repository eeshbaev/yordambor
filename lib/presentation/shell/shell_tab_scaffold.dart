import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';
import 'package:yordambor/presentation/shell/deal_box.dart';
import 'package:yordambor/presentation/shell/shell_notification_button.dart';

/// A tab page under the brand bar. Each tab other than Home carries its own
/// bar, so changing tabs cross-fades whole pages and nothing above the
/// content ever jumps or resizes.
class ShellTabScaffold extends StatelessWidget {
  const ShellTabScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(
        title: YbAppBrandTitle(
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        actions: const [DealBoxButton(), ShellNotificationButton()],
      ),
      body: child,
    );
  }
}
