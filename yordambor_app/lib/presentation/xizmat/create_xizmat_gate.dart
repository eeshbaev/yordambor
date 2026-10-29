import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/constants/xizmat_limits.dart';
import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';
import 'package:yordambor/presentation/auth/auth_gate.dart';

/// Opens "new service" when the person may add one: signed in, and under
/// [XizmatLimits.maxPerAccount] services. At the limit it says why before
/// any form is filled. [prefill] (from an invite) fills the trade and city.
Future<void> openCreateXizmat(
  BuildContext context,
  WidgetRef ref, {
  CreateXizmatPrefill? prefill,
}) async {
  final allowed = await requireVerifiedAuth(context, ref);
  if (!allowed || !context.mounted) return;

  var count = 0;
  try {
    count = (await ref.read(myXizmatlarProvider.future)).length;
  } catch (_) {
    // Unknown here; the form checks again when it saves.
  }
  if (!context.mounted) return;

  if (count >= XizmatLimits.maxPerAccount) {
    final strings = ref.read(appStringsProvider);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            strings.xizmatLimitReached(XizmatLimits.maxPerAccount),
          ),
        ),
      );
    return;
  }
  final query = prefill?.toQuery() ?? const <String, String>{};
  await context.push(
    Uri(
      path: '/create-xizmat',
      queryParameters: query.isEmpty ? null : query,
    ).toString(),
  );
}
