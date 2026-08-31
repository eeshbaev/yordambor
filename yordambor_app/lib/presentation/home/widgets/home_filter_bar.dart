import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_picker_sheet.dart';
import 'package:yordambor/presentation/home/widgets/category_picker_sheet.dart';

/// Pinned filter panel: mode switch + large tappable filter tiles.
const double kHomeFilterBarHeight = 141;

/// Room for brand row + short name line under the logo.
const double kHomeAppBarToolbarHeight = 64;

class HomeFilterBar extends ConsumerWidget {
  const HomeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final filter = ref.watch(feedFilterProvider);
    final language = ref.watch(onboardingPrefsProvider.select((p) => p.language));
    final categoriesAsync = ref.watch(categoriesProvider);
    final isYordamBor = filter.mode == FeedMode.yordamBor;
    final colors = context.ybColors;
    final hasFilters = filter.categoryId != null ||
        filter.subcategoryId != null ||
        filter.providerType != null;

    final categoryValue = categoriesAsync.maybeWhen(
      data: (categories) {
        if (filter.categoryId == null) return strings.filterAllCategories;
        for (final category in categories) {
          if (category.id == filter.categoryId) {
            return category.label(language);
          }
        }
        return filter.categoryLabel ?? strings.filterAllCategories;
      },
      orElse: () => filter.categoryLabel ?? strings.filterAllCategories,
    );

    final subcategoryValue = categoriesAsync.maybeWhen(
      data: (categories) {
        if (filter.subcategoryId == null || filter.categoryId == null) {
          return strings.filterAllSubcategories;
        }
        for (final category in categories) {
          if (category.id != filter.categoryId) continue;
          for (final subcategory in category.subcategories) {
            if (subcategory.id == filter.subcategoryId) {
              return subcategory.label(language);
            }
          }
        }
        return filter.subcategoryLabel ?? strings.filterAllSubcategories;
      },
      orElse: () => filter.subcategoryLabel ?? strings.filterAllSubcategories,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModeSwitch(
              yordamBorLabel: strings.filterYordamBor,
              yordamKerakLabel: strings.filterYordamKerak,
              mode: filter.mode,
              onModeChanged: (mode) {
                AppHaptics.selection();
                ref.read(feedFilterProvider.notifier).setMode(mode);
              },
            ),
            const SizedBox(height: AppSpacing.sm + 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _FilterTile(
                    icon: Icons.category_outlined,
                    caption: strings.filterCategory,
                    value: categoryValue,
                    active: filter.categoryId != null,
                    onTap: () => showCategoryPickerSheet(
                      context,
                      ref,
                      target: CategoryPickerTarget.category,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _FilterTile(
                    icon: Icons.account_tree_outlined,
                    caption: strings.filterSubcategory,
                    value: subcategoryValue,
                    active: filter.subcategoryId != null,
                    enabled: filter.categoryId != null,
                    onTap: () {
                      if (filter.categoryId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(strings.filterPickCategoryFirst),
                          ),
                        );
                        return;
                      }
                      showCategoryPickerSheet(
                        context,
                        ref,
                        target: CategoryPickerTarget.subcategory,
                      );
                    },
                  ),
                ),
                if (isYordamBor) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _FilterTile(
                      icon: Icons.badge_outlined,
                      caption: strings.filterProviderType,
                      value: strings.providerTypeFilterLabel(
                        filter.providerType,
                      ),
                      active: filter.providerType != null,
                      onTap: () => _showProviderTypePicker(context, ref),
                    ),
                  ),
                ],
                if (hasFilters) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _ClearFiltersButton(
                    onTap: () {
                      AppHaptics.selection();
                      ref.read(feedFilterProvider.notifier).clearFilters();
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showProviderTypePicker(BuildContext context, WidgetRef ref) {
    final strings = ref.read(appStringsProvider);
    final selected = ref.read(feedFilterProvider).providerType;

    showYbPickerSheet<void>(
      context: context,
      child: YbCompactPickerSheet(
        title: strings.filterProviderType,
        subtitle: strings.filterProviderTypeHint,
        headerIcon: Icons.badge_outlined,
        selectedId: selected ?? '',
        options: [
          YbPickerOption(
            id: '',
            label: strings.filterProviderAll,
            subtitle: strings.filterProviderAllHint,
            icon: Icons.grid_view_rounded,
          ),
          YbPickerOption(
            id: 'individual',
            label: strings.xizmatProviderIndividual,
            subtitle: strings.filterProviderIndividualHint,
            icon: Icons.person_outline_rounded,
          ),
          YbPickerOption(
            id: 'institution',
            label: strings.xizmatProviderInstitution,
            subtitle: strings.filterProviderInstitutionHint,
            icon: Icons.business_outlined,
          ),
        ],
        onSelected: (option) {
          ref.read(feedFilterProvider.notifier).setProviderType(
                option.id.isEmpty ? null : option.id,
              );
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.yordamBorLabel,
    required this.yordamKerakLabel,
    required this.mode,
    required this.onModeChanged,
  });

  final String yordamBorLabel;
  final String yordamKerakLabel;
  final FeedMode mode;
  final ValueChanged<FeedMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            Expanded(
              child: _ModeSegment(
                label: yordamBorLabel,
                icon: Icons.design_services_outlined,
                selected: mode == FeedMode.yordamBor,
                onTap: () => onModeChanged(FeedMode.yordamBor),
              ),
            ),
            Expanded(
              child: _ModeSegment(
                label: yordamKerakLabel,
                icon: Icons.campaign_outlined,
                selected: mode == FeedMode.yordamKerak,
                onTap: () => onModeChanged(FeedMode.yordamKerak),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return YbScaleTap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        height: 53,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.button - 2),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.icon,
    required this.caption,
    required this.value,
    required this.onTap,
    this.active = false,
    this.enabled = true,
  });

  final IconData icon;
  final String caption;
  final String value;
  final VoidCallback onTap;
  final bool active;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final foreground = enabled
        ? (active ? AppColors.primaryDark : AppColors.textPrimary)
        : AppColors.textSecondary.withValues(alpha: 0.55);
    final captionColor = enabled
        ? AppColors.textSecondary
        : AppColors.textSecondary.withValues(alpha: 0.45);

    return YbScaleTap(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        constraints: const BoxConstraints(minHeight: 62),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 1,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryMuted : colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: active ? AppColors.primary : colors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: active ? AppColors.primary : captionColor),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label.copyWith(
                      fontSize: 12,
                      color: captionColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.expand_more_rounded,
                  size: 20,
                  color: foreground,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs + 1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClearFiltersButton extends StatelessWidget {
  const _ClearFiltersButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return YbScaleTap(
      onTap: onTap,
      child: Container(
        width: 53,
        height: 62,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
        ),
        child: const Icon(
          Icons.filter_alt_off_outlined,
          size: 24,
          color: AppColors.error,
        ),
      ),
    );
  }
}
