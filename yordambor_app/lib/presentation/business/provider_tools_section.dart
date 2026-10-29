import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/receipt_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/invite/invite_providers.dart';

/// Provider tools as picture cards: client book, receipts, earnings and
/// margin two to a row, the business guides wide at the end. Each tool has
/// its own colour and illustration, so they are told apart at a glance.
class ProviderToolsSection extends ConsumerWidget {
  const ProviderToolsSection({super.key});

  static const _art = 'assets/illustrations/tools';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final mineAsync = ref.watch(myXizmatlarProvider);
    final receiptSubtitle = ref.watch(receiptToolSubtitleProvider);
    final lacksServices = mineAsync.maybeWhen(
      data: (items) => items.isEmpty,
      orElse: () => false,
    );

    final tools = [
      _Tool(
        image: '$_art/tool_client_book.png',
        icon: YbIcons.menuBook,
        tint: colors.tealSoft,
        title: strings.profileClientBook,
        subtitle: strings.profileClientBookSub,
        onTap: () => context.push('/client-book'),
      ),
      _Tool(
        image: '$_art/tool_receipt.png',
        icon: YbIcons.receiptLong,
        tint: colors.apricotSoft,
        title: strings.profilePaymentReceipt,
        subtitle: receiptSubtitle,
        onTap: () => openProviderTool(
          context,
          ref,
          route: '/receipts',
          lacksServices: lacksServices,
        ),
      ),
      _Tool(
        image: '$_art/tool_earnings.png',
        icon: YbIcons.payments,
        tint: colors.successSoft,
        title: strings.profileEarnings,
        subtitle: lacksServices
            ? strings.createXizmatFirst
            : strings.profileEarningsSub,
        onTap: () => openProviderTool(
          context,
          ref,
          route: '/earnings',
          lacksServices: lacksServices,
        ),
      ),
      _Tool(
        image: '$_art/tool_margin.png',
        icon: YbIcons.pieChart,
        tint: colors.placeSoft,
        title: strings.profileMargin,
        subtitle: strings.profileMarginSub,
        onTap: () => context.push('/margin'),
      ),
    ];
    final guides = _Tool(
      image: '$_art/tool_tips.png',
      icon: YbIcons.autoStories,
      tint: colors.star.withValues(alpha: 0.18),
      title: strings.guidesTitle,
      subtitle: strings.guidesSubtitle,
      onTap: () => context.push('/guides'),
    );
    // Bring in providers they know: more real services bring more clients.
    final invite = _Tool(
      icon: YbIcons.personAddFilled,
      tint: colors.tealSoft,
      title: strings.inviteTitle,
      subtitle: strings.inviteBody,
      onTap: () => showInviteProvidersSheet(context, ref),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Two to a row while titles fit; one per row with large text.
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final twoUp = constraints.maxWidth >= 320 && textScale < 1.6;
        if (!twoUp) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final tool in [...tools, guides, invite]) ...[
                _ToolCard(tool: tool, wide: true),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < tools.length; i += 2) ...[
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _ToolCard(tool: tools[i])),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: i + 1 < tools.length
                          ? _ToolCard(tool: tools[i + 1])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _ToolCard(tool: guides, wide: true),
            const SizedBox(height: AppSpacing.md),
            _ToolCard(tool: invite, wide: true),
          ],
        );
      },
    );
  }
}

class _Tool {
  const _Tool({
    this.image,
    required this.icon,
    required this.tint,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String? image;

  /// Shown without a picture, or if it cannot load.
  final IconData icon;
  final Color tint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

/// A tool: its picture on its colour, then the name and what it does. Tall
/// in the grid; [wide] puts the picture beside the words.
class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool, this.wide = false});

  final _Tool tool;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final picture = ColoredBox(
      color: tool.tint,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: tool.image == null
            ? Icon(tool.icon, size: 40, color: colors.teal)
            : Image.asset(
                tool.image!,
                fit: BoxFit.contain,
                cacheWidth: 640,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) =>
                    Icon(tool.icon, size: 40, color: colors.ink2),
              ),
      ),
    );
    final words = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tool.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 2),
        Text(
          tool.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );

    final content = wide
        ? Row(
            children: [
              SizedBox(width: 132, child: picture),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: words,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: Icon(YbIcons.chevronRight, color: colors.textTertiary),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              picture,
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: words,
              ),
            ],
          );

    return Semantics(
      button: true,
      label: '${tool.title}. ${tool.subtitle}',
      excludeSemantics: true,
      onTap: tool.onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: isDark ? Border.all(color: colors.borderSubtle) : null,
          boxShadow: isDark ? null : AppElevation.card(context),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: tool.onTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

void openProviderTool(
  BuildContext context,
  WidgetRef ref, {
  required String route,
  required bool lacksServices,
}) {
  if (lacksServices) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(appStringsProvider).createXizmatFirst)),
    );
  }
  context.push(route);
}
