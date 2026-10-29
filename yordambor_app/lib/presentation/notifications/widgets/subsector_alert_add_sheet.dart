import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/subsector_alert_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/notifications/subsector_alert_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';

Future<bool?> showSubsectorAlertAddSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const SubsectorAlertAddSheet(),
  );
}

class SubsectorAlertAddSheet extends ConsumerStatefulWidget {
  const SubsectorAlertAddSheet({super.key});

  @override
  ConsumerState<SubsectorAlertAddSheet> createState() =>
      _SubsectorAlertAddSheetState();
}

class _SubsectorAlertAddSheetState extends ConsumerState<SubsectorAlertAddSheet> {
  CategoryItem? _category;
  SubcategoryItem? _subcategory;
  bool _newService = true;
  bool _discount = true;
  bool _helpPost = false;
  bool _saving = false;

  Future<void> _pickCategory(List<CategoryItem> categories) async {
    final language = ref.read(onboardingPrefsProvider).language;
    final picked = await showModalBottomSheet<CategoryItem>(
      sheetAnimationStyle: AppMotion.sheetOf(context),
      context: context,
      builder: (context) => _PickList<CategoryItem>(
        title: ref.read(appStringsProvider).filterCategory,
        items: categories,
        label: (c) => c.label(language),
      ),
    );
    if (picked != null) {
      setState(() {
        _category = picked;
        _subcategory = null;
      });
    }
  }

  Future<void> _pickSubcategory() async {
    final category = _category;
    if (category == null) return;
    final language = ref.read(onboardingPrefsProvider).language;
    final picked = await showModalBottomSheet<SubcategoryItem>(
      sheetAnimationStyle: AppMotion.sheetOf(context),
      context: context,
      builder: (context) => _PickList<SubcategoryItem>(
        title: ref.read(appStringsProvider).filterSubcategory,
        items: category.subcategories,
        label: (s) => s.label(language),
        subtitle: (s) =>
            ref.read(appStringsProvider).providerTypeLabel(s.providerType),
      ),
    );
    if (picked != null) {
      setState(() => _subcategory = picked);
    }
  }

  Future<void> _save(AppStrings strings) async {
    final category = _category;
    final sub = _subcategory;
    if (category == null || sub == null) return;

    setState(() => _saving = true);
    try {
      await ref.read(subsectorAlertRepositoryProvider).upsert(
            UpsertSubsectorAlertInput(
              categoryId: category.id,
              subcategoryId: sub.id,
              providerType: sub.providerType,
              alertNewService: _newService,
              alertDiscount: _discount,
              alertHelpPost: _helpPost,
            ),
          );
      ref.invalidate(subsectorAlertsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.notificationAlertsSaved)),
        );
        Navigator.pop(context, true);
      }
    } on SubsectorAlertFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final language = ref.watch(onboardingPrefsProvider).language;
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => YbSheetBody(
        title: strings.notificationAlertsAdd,
        children: const [LinearProgressIndicator(minHeight: 2)],
      ),
      error: (_, _) => YbSheetBody(
        title: strings.notificationAlertsAdd,
        children: [Text(strings.profileSectionLoadFailed)],
      ),
      data: (categories) {
        return YbSheetBody(
          title: strings.notificationAlertsAdd,
          children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.filterCategory),
                subtitle: Text(
                  _category?.label(language) ?? strings.actionPick,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
                trailing: const Icon(YbIcons.chevronRightFilled),
                onTap: () => _pickCategory(categories),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.filterSubcategory),
                subtitle: Text(
                  _subcategory?.label(language) ?? strings.actionPick,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
                trailing: const Icon(YbIcons.chevronRightFilled),
                onTap: _category == null ? null : _pickSubcategory,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                strings.notificationAlertSeekerHint,
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.notificationAlertNewService),
                value: _newService,
                onChanged: (v) => setState(() => _newService = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.notificationAlertDiscount),
                value: _discount,
                onChanged: (v) => setState(() => _discount = v),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                strings.notificationAlertProviderHint,
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(strings.notificationAlertHelpPost),
                value: _helpPost,
                onChanged: (v) => setState(() => _helpPost = v),
              ),
              const SizedBox(height: AppSpacing.lg),
            YbPrimaryButton(
              label: strings.actionSave,
              isLoading: _saving,
              disabledHint: _subcategory == null
                  ? strings.disabledHintPickSubcategory
                  : strings.disabledHintOneAlert,
              onPressed: _subcategory == null ||
                      (!_newService && !_discount && !_helpPost) ||
                      _saving
                  ? null
                  : () => _save(strings),
            ),
          ],
        );
      },
    );
  }
}

class _PickList<T> extends StatelessWidget {
  const _PickList({
    required this.title,
    required this.items,
    required this.label,
    this.subtitle,
  });

  final String title;
  final List<T> items;
  final String Function(T item) label;
  final String Function(T item)? subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(title, style: AppTypography.title.copyWith(color: context.ybColors.textPrimary)),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(label(item)),
                  subtitle:
                      subtitle != null ? Text(subtitle!(item)) : null,
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
