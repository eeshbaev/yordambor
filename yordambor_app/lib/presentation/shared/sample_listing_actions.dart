import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/home/widgets/create_yordam_kerak_sheet.dart';
import 'package:yordambor/presentation/shared/alert_subscriptions.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';

/// Samples never take a deal. Someone who wants a sample service gets to
/// post a real request in its trade and city (and hear when a provider
/// joins there); someone who answers a sample request gets alerts for the
/// real ones. Interest in a sample becomes something real.

/// "Find a provider" on a sample service.
Future<void> findProviderFromSample(
  BuildContext context,
  WidgetRef ref,
  XizmatFeedItem sample,
) async {
  final allowed = await requireVerifiedAuth(
    context,
    ref,
    authContext: AuthContextType.postJob,
  );
  if (!allowed || !context.mounted) return;

  final strings = ref.read(appStringsProvider);
  final messenger = ScaffoldMessenger.of(context);
  final published = await showCreateYordamKerakSheet(
    context,
    prefill: YordamKerakPrefill(
      categoryId: sample.categoryId.isEmpty ? null : sample.categoryId,
      subcategoryId: sample.subcategoryId.isEmpty ? null : sample.subcategoryId,
      serviceCityId: ServiceCities.resolveForFeed(
        sample.serviceCity,
        isDemo: sample.isDemo,
        listingId: sample.id,
      ),
    ),
    offerNewServiceAlert: true,
  );
  if (published == true) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(strings.sampleRequestPosted)));
  }
}

enum _SampleRequestAction { alerts, addService }

/// "Yordam bor" on a sample request: what it is, and alerts for real ones;
/// someone with no service yet can add one instead.
Future<void> answerSampleRequest(
  BuildContext context,
  WidgetRef ref,
  YordamKerakFeedItem sample,
) async {
  final strings = ref.read(appStringsProvider);
  final hasServices =
      (ref.read(myXizmatlarProvider).valueOrNull ?? const []).isNotEmpty;
  final action = await showModalBottomSheet<_SampleRequestAction>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _SampleRequestSheet(
      strings: strings,
      hasServices: hasServices,
    ),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _SampleRequestAction.addService:
      await openCreateXizmat(context, ref);
    case _SampleRequestAction.alerts:
      final messenger = ScaffoldMessenger.of(context);
      final allowed = await requireVerifiedAuth(context, ref);
      if (!allowed || !context.mounted) return;
      final ok = await subscribeToHelpPosts(
        ref,
        categoryId: sample.categoryId,
        subcategoryId: sample.subcategoryId,
      );
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(ok ? strings.sampleAlertOn : strings.stateErrorBody),
          ),
        );
  }
}

class _SampleRequestSheet extends StatelessWidget {
  const _SampleRequestSheet({
    required this.strings,
    required this.hasServices,
  });

  final AppStrings strings;
  final bool hasServices;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return YbSheetBody(
      title: strings.sampleRequestTitle,
      subtitle: strings.sampleRequestBody,
      children: [
        Center(
          child: Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.tealSoft,
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Icon(
              YbIcons.notificationsActiveFilled,
              color: colors.teal,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.sampleAlertHelpPosts,
          icon: YbIcons.notificationsActiveFilled,
          onPressed: () =>
              Navigator.of(context).pop(_SampleRequestAction.alerts),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (!hasServices)
          YbSecondaryButton(
            label: strings.feedInviteProvidersAction,
            icon: YbIcons.addBusiness,
            onPressed: () =>
                Navigator.of(context).pop(_SampleRequestAction.addService),
          )
        else
          YbSecondaryButton(
            label: strings.actionClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
      ],
    );
  }
}
