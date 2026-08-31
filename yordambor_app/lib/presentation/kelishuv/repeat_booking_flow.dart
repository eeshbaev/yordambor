import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/app_review_service.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/utils/xizmat_pricing_display.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';

Future<void> openRepeatBookFlow(
  BuildContext context,
  WidgetRef ref, {
  required Kelishuv kelishuv,
}) async {
  final userId = ref.read(sessionProvider).user?.id;
  if (userId == null || !kelishuv.canRepeatBook(userId)) return;

  final xizmatId = kelishuv.xizmatId;
  if (xizmatId == null) return;

  await _openRepeatBookWithPrefill(
    context,
    ref,
    xizmatId: xizmatId,
    prefill: taklifPrefillFromKelishuv(kelishuv),
    xizmatName: kelishuv.xizmatName,
  );
}

Future<void> openRepeatBookFromSummary(
  BuildContext context,
  WidgetRef ref, {
  required KelishuvSummary summary,
}) async {
  if (!summary.canRepeatBook) return;

  final xizmatId = summary.xizmatId;
  if (xizmatId == null) return;

  await _openRepeatBookWithPrefill(
    context,
    ref,
    xizmatId: xizmatId,
    prefill: taklifPrefillFromKelishuvSummary(summary),
    xizmatName: summary.xizmatName,
  );
}

Future<void> _openRepeatBookWithPrefill(
  BuildContext context,
  WidgetRef ref, {
  required String xizmatId,
  required TaklifPricingPrefill prefill,
  String? xizmatName,
}) async {
  final strings = ref.read(appStringsProvider);
  final xizmat = await ref.read(xizmatDetailProvider(xizmatId).future);
  if (!context.mounted) return;

  final userId = ref.read(sessionProvider).user?.id;
  if (userId != null && xizmat?.ownerId == userId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.cannotRequestOwnXizmat)),
    );
    return;
  }

  final mergedPrefill = mergeTaklifPrefill(
    prefill,
    xizmat == null ? null : taklifPrefillFromXizmat(xizmat),
  );

  final kelishuvId = await showTaklifSheet(
    context,
    target: TaklifTarget.xizmat(xizmatId: xizmatId),
    title: strings.repeatBookTitle,
    prefill: mergedPrefill,
  );

  if (kelishuvId != null && context.mounted) {
    await maybePromptAppReview(
      context,
      ref,
      trigger: AppReviewTrigger.repeatBooking,
    );
    if (context.mounted) {
      context.push('/kelishuv/$kelishuvId');
    }
  }
}
