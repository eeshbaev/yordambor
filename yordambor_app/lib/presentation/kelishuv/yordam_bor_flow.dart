import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';

Future<void> openYordamBorForPost(
  BuildContext context,
  WidgetRef ref, {
  required String postId,
  String? subcategoryId,
}) async {
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
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(strings.pickXizmat, style: AppTypography.title),
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
