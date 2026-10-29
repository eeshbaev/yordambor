import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/search_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_network_image.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/home/widgets/create_yordam_kerak_sheet.dart';

/// Search: a provider's name, an organization's name, a service or a
/// trade. Results come as the person types, a moment after they pause.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() => _query = '');
  }

  Future<void> _ask() async {
    final allowed = await requireVerifiedAuth(
      context,
      ref,
      authContext: AuthContextType.postJob,
    );
    if (!allowed || !mounted) return;
    await showCreateYordamKerakSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: (text) {
            _debounce?.cancel();
            setState(() => _query = text.trim());
          },
          style: AppTypography.body.copyWith(color: colors.ink),
          decoration: InputDecoration(
            hintText: strings.searchHint,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            isDense: true,
          ),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              tooltip: strings.actionClose,
              icon: const Icon(YbIcons.close),
              onPressed: _clear,
            ),
        ],
      ),
      body: _query.length < 2
          ? _Prompt(text: strings.searchPrompt)
          : ref.watch(xizmatSearchProvider(_query)).when(
                loading: () => const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
                error: (_, _) => YbEmptyState(
                  icon: YbIcons.cloudOff,
                  title: strings.stateErrorTitle,
                  subtitle: strings.stateErrorBody,
                  actionLabel: strings.actionRetry,
                  onAction: () => ref.invalidate(xizmatSearchProvider(_query)),
                ),
                data: (result) {
                  if (result.items.isEmpty) {
                    return _NothingFound(
                      strings: strings,
                      offline: result.failed,
                      onAsk: _ask,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: result.items.length + (result.failed ? 1 : 0),
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: AppSpacing.lg + 64,
                      color: colors.line,
                    ),
                    itemBuilder: (context, index) {
                      if (result.failed && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            0,
                            AppSpacing.lg,
                            AppSpacing.sm,
                          ),
                          child: YbInlineMessage(message: strings.searchOffline),
                        );
                      }
                      final item =
                          result.items[index - (result.failed ? 1 : 0)];
                      return _ResultTile(item: item, strings: strings);
                    },
                  );
                },
              ),
    );
  }
}

/// Before two letters are typed: what can be searched.
class _Prompt extends StatelessWidget {
  const _Prompt({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.tealSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(YbIcons.search, size: 30, color: colors.teal),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTypography.bodyRegular.copyWith(color: colors.ink2),
          ),
        ],
      ),
    );
  }
}

/// Nothing matches: a request instead, so the providers come to them.
class _NothingFound extends StatelessWidget {
  const _NothingFound({
    required this.strings,
    required this.offline,
    required this.onAsk,
  });

  final AppStrings strings;
  final bool offline;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        if (offline) ...[
          YbInlineMessage(message: strings.searchOffline),
          const SizedBox(height: AppSpacing.lg),
        ],
        const SizedBox(height: AppSpacing.lg),
        Icon(YbIcons.searchOff, size: 48, color: colors.ink3),
        const SizedBox(height: AppSpacing.md),
        Text(
          strings.searchNoResults,
          textAlign: TextAlign.center,
          style: AppTypography.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          strings.searchNoResultsHint,
          textAlign: TextAlign.center,
          style: AppTypography.bodyRegular.copyWith(color: colors.ink2),
        ),
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.quickAskHelp,
          icon: YbIcons.campaign,
          tone: YbButtonTone.ask,
          onPressed: onAsk,
        ),
      ],
    );
  }
}

/// One service: its photo, its name, who gives it and where.
class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.item, required this.strings});

  final XizmatFeedItem item;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final icon = CategoryIcons.forService(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
    );
    final tint = CategoryIcons.tint(context, item.categoryId);
    final city = strings.serviceCityDisplayLabel(item.serviceCity);
    final details = [
      if (item.showsOwnerProfile) item.displayOwnerName,
      item.subcategoryLabel,
      ?city,
    ].where((part) => part.trim().isNotEmpty).join(' · ');

    return InkWell(
      onTap: () => context.push('/xizmat/${item.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm + 4),
              child: SizedBox(
                width: 56,
                height: 56,
                child: item.heroImageUrl.isEmpty
                    ? ColoredBox(
                        color: tint.fill,
                        child: Icon(icon, color: tint.ink),
                      )
                    : YbNetworkImage(
                        url: item.heroImageUrl,
                        width: 56,
                        height: 56,
                        placeholderIcon: icon,
                        errorIcon: icon,
                        placeholderColor: tint.fill,
                        placeholderIconColor: tint.ink,
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.serviceDisplayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headline.copyWith(
                      color: colors.ink,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption.copyWith(color: colors.ink2),
                  ),
                  if (item.isDemo) ...[
                    const SizedBox(height: 6),
                    YbInfoTag(icon: YbIcons.info, label: strings.sampleTag),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(YbIcons.chevronRightFilled, color: colors.ink3),
          ],
        ),
      ),
    );
  }
}
