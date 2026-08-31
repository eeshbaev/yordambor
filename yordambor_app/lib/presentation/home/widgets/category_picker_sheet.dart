import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_picker_sheet.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/category_item.dart';

enum CategoryPickerTarget { category, subcategory }

Future<void> showCategoryPickerSheet(
  BuildContext context,
  WidgetRef ref, {
  required CategoryPickerTarget target,
}) async {
  await showYbPickerSheet<void>(
    context: context,
    child: CategoryPickerSheet(target: target),
  );
}

class CategoryPickerSheet extends ConsumerWidget {
  const CategoryPickerSheet({super.key, required this.target});

  final CategoryPickerTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(onboardingPrefsProvider).language;
    final strings = ref.watch(appStringsProvider);
    final filter = ref.watch(feedFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.ybColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.sheet),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.ybColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              Expanded(
                child: categoriesAsync.when(
                  loading: () => const Center(child: YbSkeletonList(count: 6)),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: YbInlineMessage(message: '$error'),
                  ),
                  data: (categories) {
                    if (target == CategoryPickerTarget.category) {
                      return _CategoryList(
                        scrollController: scrollController,
                        categories: categories,
                        language: language,
                        strings: strings,
                        selectedId: filter.categoryId,
                        onSelected: (category) {
                          ref.read(feedFilterProvider.notifier).setCategory(
                                category.id,
                                label: category.label(language),
                              );
                          Navigator.pop(context);
                        },
                        onClear: () {
                          ref.read(feedFilterProvider.notifier).setCategory(null);
                          Navigator.pop(context);
                        },
                      );
                    }

                    final category = categories.firstWhere(
                      (item) => item.id == filter.categoryId,
                      orElse: () => categories.first,
                    );

                    return _SubcategoryList(
                      scrollController: scrollController,
                      category: category,
                      language: language,
                      strings: strings,
                      providerType: filter.providerType,
                      selectedId: filter.subcategoryId,
                      selectedProviderType: filter.providerType,
                      onSelected: (subcategory) {
                        ref.read(feedFilterProvider.notifier).setSubcategory(
                              subcategory.id,
                              label: subcategory.label(language),
                              providerType: subcategory.providerType,
                            );
                        Navigator.pop(context);
                      },
                      onClear: () {
                        ref.read(feedFilterProvider.notifier).clearSubcategory();
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.scrollController,
    required this.categories,
    required this.language,
    required this.strings,
    required this.selectedId,
    required this.onSelected,
    required this.onClear,
  });

  final ScrollController scrollController;
  final List<CategoryItem> categories;
  final String language;
  final AppStrings strings;
  final String? selectedId;
  final ValueChanged<CategoryItem> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YbPickerSheetHeader(
          title: strings.categoryPickTitle,
          subtitle: strings.filterCategoryHint,
          icon: Icons.category_outlined,
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              YbPickerOptionTile(
                label: strings.categoryAll,
                subtitle: strings.filterAllCategoriesHint,
                icon: Icons.apps_rounded,
                selected: selectedId == null,
                onTap: onClear,
              ),
              for (final category in categories)
                YbPickerOptionTile(
                  label: category.label(language),
                  emoji: category.icon,
                  selected: selectedId == category.id,
                  onTap: () => onSelected(category),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubcategoryList extends StatelessWidget {
  const _SubcategoryList({
    required this.scrollController,
    required this.category,
    required this.language,
    required this.strings,
    this.providerType,
    required this.selectedId,
    required this.selectedProviderType,
    required this.onSelected,
    required this.onClear,
  });

  final ScrollController scrollController;
  final CategoryItem category;
  final String language;
  final AppStrings strings;
  final String? providerType;
  final String? selectedId;
  final String? selectedProviderType;
  final ValueChanged<SubcategoryItem> onSelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final subs = providerType == null
        ? category.subcategories
        : category.subcategories
            .where((sub) => sub.providerType == providerType)
            .toList();

    final providerHint = providerType == null
        ? null
        : providerType == 'institution'
            ? strings.xizmatProviderInstitution
            : strings.xizmatProviderIndividual;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YbPickerSheetHeader(
          title: strings.filterSubcategory,
          subtitle: providerHint ?? category.label(language),
          icon: Icons.account_tree_outlined,
        ),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: [
              YbPickerOptionTile(
                label: strings.subcategoryAll,
                subtitle: strings.filterAllSubcategoriesHint,
                icon: Icons.layers_outlined,
                selected: selectedId == null,
                onTap: onClear,
              ),
              for (final subcategory in subs)
                YbPickerOptionTile(
                  label: subcategory.label(language),
                  subtitle: providerType == null
                      ? (subcategory.providerType == 'institution'
                          ? strings.xizmatProviderInstitution
                          : strings.xizmatProviderIndividual)
                      : null,
                  icon: subcategory.providerType == 'institution'
                      ? Icons.business_outlined
                      : Icons.person_outline_rounded,
                  selected: selectedId == subcategory.id &&
                      selectedProviderType == subcategory.providerType,
                  onTap: () => onSelected(subcategory),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
