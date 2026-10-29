import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/demo_ids.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/presentation/shared/sample_listing_actions.dart';

/// "Yordam bor" on a request card or page. A sample explains itself first,
/// with no sign-in needed to read it; a real request goes through sign-in
/// to the offer.
Future<void> answerHelpRequest(
  BuildContext context,
  WidgetRef ref,
  YordamKerakFeedItem item,
) async {
  if (item.isDemo || isDemoFeedId(item.id)) {
    await answerSampleRequest(context, ref, item);
    return;
  }
  final allowed = await requireVerifiedAuth(
    context,
    ref,
    authContext: AuthContextType.yordamBor,
  );
  if (!allowed || !context.mounted) return;
  await openYordamBorForPost(
    context,
    ref,
    postId: item.id,
    subcategoryId: item.subcategoryId,
  );
}

Future<void> openYordamBorForPost(
  BuildContext context,
  WidgetRef ref, {
  required String postId,
  String? subcategoryId,
}) async {
  // Samples never take an offer.
  if (isDemoFeedId(postId)) {
    final sample = await ref.read(yordamKerakPostProvider(postId).future);
    if (sample != null && context.mounted) {
      await answerSampleRequest(context, ref, sample);
    }
    return;
  }

  final xizmatlar = await ref.read(myXizmatlarProvider.future);
  if (!context.mounted) return;

  if (xizmatlar.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(appStringsProvider).createXizmatFirst)),
    );
    context.push('/create-xizmat');
    return;
  }

  final XizmatFeedItem xizmat;
  if (xizmatlar.length == 1) {
    xizmat = xizmatlar.first;
  } else if (subcategoryId != null) {
    final matched = xizmatlar
        .where((item) => item.subcategoryId == subcategoryId)
        .toList();
    if (matched.length == 1) {
      xizmat = matched.first;
    } else {
      final picked = await _pickXizmat(context, ref, xizmatlar);
      if (picked == null || !context.mounted) return;
      xizmat = picked;
    }
  } else {
    final picked = await _pickXizmat(context, ref, xizmatlar);
    if (picked == null || !context.mounted) return;
    xizmat = picked;
  }

  await openTaklifFlow(
    context,
    ref,
    target: TaklifTarget.post(postId: postId, xizmatId: xizmat.id),
    title: ref.read(appStringsProvider).taklifFlowTitleYordamBor(xizmat.name),
  );
}

Future<XizmatFeedItem?> _pickXizmat(
  BuildContext context,
  WidgetRef ref,
  List<XizmatFeedItem> items,
) {
  final strings = ref.read(appStringsProvider);
  return showModalBottomSheet<XizmatFeedItem>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(strings.pickXizmat, style: AppTypography.title.copyWith(color: context.ybColors.textPrimary)),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.serviceDisplayName),
                  subtitle: Text(item.subcategoryLabel),
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
