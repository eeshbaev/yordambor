import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/core/router/app_router.dart';

/// Opens [ResetPasswordScreen] when Supabase reports a password recovery session.
class AuthRecoveryListener extends ConsumerWidget {
  const AuthRecoveryListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionProvider, (previous, next) {
      if (next.authEvent != AuthChangeEvent.passwordRecovery) return;

      final router = ref.read(routerProvider);
      if (router.state.matchedLocation == '/reset-password') return;

      router.go('/reset-password');
    });

    return child;
  }
}
