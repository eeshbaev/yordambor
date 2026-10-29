import 'dart:math' as math;

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
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/presentation/home/widgets/category_picker_sheet.dart';

/// Height of one side of the mode switch: 51 dp, taller with large text so
/// the label never clips (manual T-02).
double homeModeSegmentHeight(BuildContext context) {
  final label = MediaQuery.textScalerOf(context).scale(15);
  return math.max(51, label * 1.4 + 24);
}

/// The pinned mode switch with its padding: segment, track, margins and
/// the hairline under it.
double homeModeSwitchExtent(BuildContext context) =>
    homeModeSegmentHeight(context) + 8 + AppSpacing.sm * 2 + 1;

/// "Yordam bor / Yordam kerak", pinned on home. The filters under it
/// scroll away with the feed and come back as soon as it scrolls up.
class HomeModeSwitch extends ConsumerWidget {
  const HomeModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final mode = ref.watch(feedFilterProvider.select((f) => f.mode));

    return _ModeSwitch(
      yordamBorLabel: strings.filterYordamBor,
      yordamKerakLabel: strings.filterYordamKerak,
      mode: mode,
      segmentHeight: homeModeSegmentHeight(context),
      onModeChanged: (next) {
        if (next == mode) return;
        AppHaptics.selection();
        ref.read(feedFilterProvider.notifier).setMode(next);
      },
    );
  }
}

/// Category, subcategory, provider type and city as large tiles. They grow
/// with the text size; nothing here has a fixed height.
class HomeFilterTiles extends ConsumerWidget {
  const HomeFilterTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final filter = ref.watch(feedFilterProvider);
    final language = ref.watch(onboardingPrefsProvider.select((p) => p.language));
    final categoriesAsync = ref.watch(categoriesProvider);
    final isYordamBor = filter.mode == FeedMode.yordamBor;
    final hasFilters = filter.categoryId != null ||
        filter.subcategoryId != null ||
        filter.providerType != null ||
        filter.serviceCityId != null;

    final cityValue = filter.serviceCityId == null
        ? strings.filterAllCities
        : strings.serviceCityLabel(filter.serviceCityId!);

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

    final categoryTile = _FilterTile(
      icon: YbIcons.category,
      caption: strings.filterCategory,
      value: categoryValue,
      active: filter.categoryId != null,
      onTap: () => showCategoryPickerSheet(
        context,
        ref,
        target: CategoryPickerTarget.category,
      ),
    );
    // Off until a category is chosen; a tap says why (manual S-07).
    final subcategoryTile = _FilterTile(
      icon: YbIcons.accountTree,
      caption: strings.filterSubcategory,
      value: subcategoryValue,
      active: filter.subcategoryId != null,
      enabled: filter.categoryId != null,
      disabledHint: strings.filterPickCategoryFirst,
      onTap: () {
        if (filter.categoryId == null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(strings.filterPickCategoryFirst)),
            );
          return;
        }
        showCategoryPickerSheet(
          context,
          ref,
          target: CategoryPickerTarget.subcategory,
        );
      },
    );
    final providerTile = _FilterTile(
      icon: YbIcons.badge,
      caption: strings.filterProviderType,
      value: strings.providerTypeFilterLabel(filter.providerType),
      active: filter.providerType != null,
      onTap: () => _showProviderTypePicker(context, ref),
    );
    final cityTile = _FilterTile(
      icon: YbIcons.locationOn,
      caption: strings.filterCity,
      value: cityValue,
      active: filter.serviceCityId != null,
      onTap: () => _showCityPicker(context, ref),
    );
    void clearFilters() {
      AppHaptics.selection();
      ref.read(feedFilterProvider.notifier).clearFilters();
    }

    const padding = EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      AppSpacing.sm,
    );

    // Large text: one tile per row, so captions and values are not cut
    // (manual T-02).
    if (MediaQuery.textScalerOf(context).scale(14) / 14 >= 1.5) {
      final tiles = [
        categoryTile,
        subcategoryTile,
        if (isYordamBor) providerTile,
        cityTile,
      ];
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, tile) in tiles.indexed) ...[
              if (index > 0) const SizedBox(height: AppSpacing.sm),
              tile,
            ],
            if (hasFilters) ...[
              const SizedBox(height: AppSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(YbIcons.filterAltOff),
                  label: Text(strings.filtersClear),
                  style: TextButton.styleFrom(
                    foregroundColor: context.ybColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: categoryTile),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: subcategoryTile),
              if (isYordamBor) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: providerTile),
              ],
              if (hasFilters) ...[
                const SizedBox(width: AppSpacing.xs),
                _ClearFiltersButton(
                  label: strings.filtersClear,
                  onTap: clearFilters,
                ),
              ],
            ],
          ),
          // Every listing has a city, so both feeds filter by it.
          const SizedBox(height: AppSpacing.sm),
          cityTile,
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context, WidgetRef ref) {
    final strings = ref.read(appStringsProvider);
    final selected = ref.read(feedFilterProvider).serviceCityId;

    showYbPickerSheet<void>(
      context: context,
      child: YbCompactPickerSheet(
        title: strings.filterCity,
        subtitle: strings.filterCityHint,
        headerIcon: YbIcons.locationCity,
        selectedId: selected ?? '',
        options: [
          YbPickerOption(
            id: '',
            label: strings.filterAllCities,
            subtitle: strings.filterAllCitiesHint,
            icon: YbIcons.public,
          ),
          for (final id in ServiceCityIds.all)
            YbPickerOption(
              id: id,
              label: strings.serviceCityLabel(id),
              icon: YbIcons.place,
            ),
        ],
        onSelected: (option) {
          ref.read(feedFilterProvider.notifier).setServiceCity(
                option.id.isEmpty ? null : option.id,
              );
          Navigator.pop(context);
        },
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
        headerIcon: YbIcons.badge,
        selectedId: selected ?? '',
        options: [
          YbPickerOption(
            id: '',
            label: strings.filterProviderAll,
            subtitle: strings.filterProviderAllHint,
            icon: YbIcons.gridViewFilled,
          ),
          YbPickerOption(
            id: 'individual',
            label: strings.xizmatProviderIndividual,
            subtitle: strings.filterProviderIndividualHint,
            icon: YbIcons.person,
          ),
          YbPickerOption(
            id: 'institution',
            label: strings.xizmatProviderInstitution,
            subtitle: strings.filterProviderInstitutionHint,
            icon: YbIcons.business,
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
    required this.segmentHeight,
    required this.onModeChanged,
  });

  final String yordamBorLabel;
  final String yordamKerakLabel;
  final FeedMode mode;
  final double segmentHeight;
  final ValueChanged<FeedMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    // Two sides, each always in its own colour: "Yordam bor" teal,
    // "Yordam kerak" apricot. The chosen side fills with its colour; the
    // other keeps a soft tint of its own.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: _ModeSegment(
                label: yordamBorLabel,
                icon: YbIcons.designServices,
                selectedIcon: YbIcons.designServicesFilled,
                height: segmentHeight,
                selected: mode == FeedMode.yordamBor,
                onTap: () => onModeChanged(FeedMode.yordamBor),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _ModeSegment(
                label: yordamKerakLabel,
                icon: YbIcons.campaign,
                selectedIcon: YbIcons.campaignFilled,
                height: segmentHeight,
                need: true,
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
    required this.selectedIcon,
    required this.height,
    required this.selected,
    required this.onTap,
    this.need = false,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final double height;
  final bool selected;
  final VoidCallback onTap;

  /// The "Yordam kerak" side speaks in apricot; "Yordam bor" in teal.
  final bool need;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final (Color fill, Color foreground) = switch ((need, selected)) {
      (false, true) => (colors.teal, colors.onTeal),
      (false, false) => (colors.tealSoft, colors.tealInk),
      (true, true) => (colors.apricot, colors.onApricot),
      (true, false) => (colors.apricotSoft, colors.apricotInk),
    };

    // One of two: a screen reader says which side is chosen.
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: YbScaleTap(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.snap,
          height: height,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: fill.withValues(alpha: 0.32),
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
                selected ? selectedIcon : icon,
                size: 20,
                color: foreground,
              ),
              const SizedBox(width: AppSpacing.xs + 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
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
    this.disabledHint,
  });

  final IconData icon;
  final String caption;
  final String value;

  /// Called even while the tile is off, so it can say what unlocks it.
  final VoidCallback onTap;
  final bool active;
  final bool enabled;

  /// What a screen reader adds while the tile is off.
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final foreground = enabled
        ? (active ? context.ybColors.tealInk : context.ybColors.textPrimary)
        : context.ybColors.textSecondary.withValues(alpha: 0.55);
    final captionColor = enabled
        ? context.ybColors.textSecondary
        : context.ybColors.textSecondary.withValues(alpha: 0.45);

    // Read as "Kategoriya: Barcha kategoriyalar", a button.
    return Semantics(
      container: true,
      button: true,
      selected: active,
      label: '$caption: $value',
      hint: enabled ? null : disabledHint,
      onTap: onTap,
      excludeSemantics: true,
      child: YbScaleTap(
        onTap: onTap,
        excludeFromSemantics: true,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          constraints: const BoxConstraints(minHeight: 62),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 1,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            color: active ? colors.tealSoft : colors.card,
            borderRadius: BorderRadius.circular(AppRadius.field),
            border: Border.all(
              color: active ? colors.teal : colors.line,
              width: active ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: active ? context.ybColors.teal : captionColor,
                  ),
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
                    YbIcons.expandMoreFilled,
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
                  fontWeight: FontWeight.w600,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClearFiltersButton extends StatelessWidget {
  const _ClearFiltersButton({required this.label, required this.onTap});

  /// Said by screen readers and shown on long press.
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      onTap: onTap,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: YbScaleTap(
          onTap: onTap,
          excludeFromSemantics: true,
          child: Container(
            width: 53,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.ybColors.errorSoft,
              borderRadius: BorderRadius.circular(AppRadius.field),
            ),
            child: Icon(
              YbIcons.filterAltOff,
              size: 24,
              color: context.ybColors.error,
            ),
          ),
        ),
      ),
    );
  }
}
