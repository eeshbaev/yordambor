import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_profile_menu.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/guides/guides_catalog.dart';

class GuidesListScreen extends StatelessWidget {
  const GuidesListScreen({super.key, required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.guidesTitle)),
      body: AppLayout.page(
        context: context,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              strings.guidesSubtitle,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            YbProfileMenuSection(
              children: [
                for (final article in GuidesCatalog.articles)
                  YbProfileMenuTile(
                    icon: _iconFor(article.icon),
                    title: strings.guideTitle(article.slug),
                    onTap: () => context.push('/guides/${article.slug}'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) => switch (name) {
        'design' => Icons.design_services_outlined,
        'payments' => Icons.payments_outlined,
        'replay' => Icons.replay_outlined,
        'verified' => Icons.verified_outlined,
        'rate' => Icons.rate_review_outlined,
        _ => Icons.menu_book_outlined,
      };
}

class GuideDetailScreen extends StatelessWidget {
  const GuideDetailScreen({
    super.key,
    required this.slug,
    required this.strings,
  });

  final String slug;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(title: Text(strings.guideTitle(slug))),
      body: AppLayout.page(
        context: context,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              strings.guideBody(slug),
              style: AppTypography.body.copyWith(
                color: colors.textPrimary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
