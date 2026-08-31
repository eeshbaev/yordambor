import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_profile_menu.dart';
import 'package:yordambor/presentation/support/feedback_sheet.dart';

class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsHelp)),
      body: AppLayout.page(
        context: context,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            YbProfileMenuSection(
              children: [
                YbProfileMenuTile(
                  icon: Icons.bug_report_outlined,
                  title: strings.supportReportTitle,
                  subtitle: strings.supportReportSubtitle,
                  onTap: () => context.push('/support/report'),
                ),
                YbProfileMenuTile(
                  icon: Icons.rate_review_outlined,
                  title: strings.feedbackTitle,
                  subtitle: strings.feedbackSubtitle,
                  onTap: () => showFeedbackSheet(context),
                ),
                YbProfileMenuTile(
                  icon: Icons.menu_book_outlined,
                  title: strings.guidesTitle,
                  subtitle: strings.guidesSubtitle,
                  onTap: () => context.push('/guides'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              strings.supportContactHint,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
