import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/application/providers/subsector_alert_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_label_resolver.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';
import 'package:yordambor/presentation/notifications/widgets/subsector_alert_add_sheet.dart';

/// The person's sub-sector alerts with their switches. [where] limits the
/// rows (inside a service: the alerts made for it); [showAdd] offers a new
/// alert by hand; [hideWhenEmpty] draws nothing when no row is left.
class SubsectorAlertsSection extends ConsumerWidget {
  const SubsectorAlertsSection({
    super.key,
    this.where,
    this.showAdd = true,
    this.hideWhenEmpty = false,
    this.showOrigin = true,
  });

  final bool Function(SubsectorAlertSubscription item)? where;
  final bool showAdd;
  final bool hideWhenEmpty;

  /// Whether rows made for a service carry their "for your service" tag.
  final bool showOrigin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final alertsAsync = ref.watch(subsectorAlertsProvider);
    ref.watch(categoriesProvider);
    final language = ref.watch(onboardingPrefsProvider).language;
    final resolver = ref.watch(categoryLabelResolverProvider);
    final filter = where;
    final visible = alertsAsync.whenData(
      (items) =>
          filter == null ? items : items.where(filter).toList(growable: false),
    );
    if (hideWhenEmpty && (visible.valueOrNull?.isEmpty ?? true)) {
      return const SizedBox.shrink();
    }

    return YbSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.notificationAlertsTitle,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      strings.notificationAlertsSubtitle,
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (showAdd)
                IconButton(
                  tooltip: strings.notificationAlertsAdd,
                  onPressed: () => showSubsectorAlertAddSheet(context),
                  icon: const Icon(YbIcons.addCircle),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          visible.when(
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (_, _) => Text(
              strings.profileSectionLoadFailed,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      strings.notificationAlertsEmpty,
                      style: AppTypography.bodyRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (showAdd)
                      YbSecondaryButton(
                        label: strings.notificationAlertsAdd,
                        icon: YbIcons.addFilled,
                        onPressed: () => showSubsectorAlertAddSheet(context),
                      ),
                  ],
                );
              }

              return Column(
                children: [
                  for (final item in items)
                    _AlertSubscriptionTile(
                      item: item,
                      label: _labelFor(item, resolver, language, strings),
                      strings: strings,
                      showOrigin: showOrigin,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _labelFor(
    SubsectorAlertSubscription item,
    CategoryLabelResolver resolver,
    String language,
    AppStrings strings,
  ) {
    final category = resolver.categoryLabel(item.categoryId, language);
    final sub = resolver.subcategoryLabel(
      item.categoryId,
      item.subcategoryId,
      language,
    );
    final type = strings.providerTypeLabel(item.providerType);
    final city = item.serviceCity == null
        ? strings.alertAnyCity
        : strings.serviceCityLabel(item.serviceCity!);
    return '$category · $sub ($type) · $city';
  }
}

class _AlertSubscriptionTile extends ConsumerWidget {
  const _AlertSubscriptionTile({
    required this.item,
    required this.label,
    required this.strings,
    required this.showOrigin,
  });

  final SubsectorAlertSubscription item;
  final String label;
  final AppStrings strings;
  final bool showOrigin;

  Future<void> _update(
    WidgetRef ref,
    SubsectorAlertSubscription updated,
  ) async {
    final repo = ref.read(subsectorAlertRepositoryProvider);
    // An alert made for a service stays, switched off: deleting it would
    // only have the next edit of the service make it again.
    if (!updated.hasAnyAlert && !item.fromService) {
      await repo.delete(item.id);
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text(strings.notificationAlertsRemoved)),
        );
      }
    } else {
      await repo.updateFlags(
        id: item.id,
        alertNewService: updated.alertNewService,
        alertDiscount: updated.alertDiscount,
        alertHelpPost: updated.alertHelpPost,
        keepWhenOff: item.fromService,
      );
    }
    ref.invalidate(subsectorAlertsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (item.fromService && showOrigin) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: YbInfoTag(
                icon: YbIcons.storefrontFilled,
                label: strings.alertFromServiceTag,
                tone: YbInfoTone.service,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              strings.alertFromServiceHint,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              strings.notificationAlertNewService,
              style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
            ),
            value: item.alertNewService,
            onChanged: (v) => _update(ref, item.copyWith(alertNewService: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              strings.notificationAlertDiscount,
              style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
            ),
            value: item.alertDiscount,
            onChanged: (v) => _update(ref, item.copyWith(alertDiscount: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              strings.notificationAlertHelpPost,
              style: AppTypography.caption.copyWith(color: context.ybColors.textSecondary),
            ),
            value: item.alertHelpPost,
            onChanged: (v) => _update(ref, item.copyWith(alertHelpPost: v)),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
