import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/auth/auth_requirement.dart';
import 'package:yordambor/presentation/auth/auth_bottom_sheet.dart';

Future<bool> requireVerifiedAuth(
  BuildContext context,
  WidgetRef ref, {
  AuthContextType authContext = AuthContextType.generic,
  AuthRequirement requirement = AuthRequirement.account,
}) async {
  final session = ref.read(sessionProvider);

  if (!session.isAuthenticated) {
    final signedIn = await showAuthBottomSheet(
      context,
      ref,
      authContext: authContext,
    );
    if (!signedIn || !context.mounted) return false;
  }

  final updated = ref.read(sessionProvider);
  if (requirement == AuthRequirement.none) {
    return true;
  }

  return updated.isAuthenticated;
}
