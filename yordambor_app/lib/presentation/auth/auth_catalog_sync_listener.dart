import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';

/// Refreshes catalog providers when auth/session becomes ready or the user changes.
class AuthCatalogSyncListener extends ConsumerWidget {
  const AuthCatalogSyncListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      sessionProvider.select((s) => (s.isLoading, s.user?.id)),
      (previous, next) {
        final idChanged = previous?.$2 != next.$2;
        final becameReady = (previous?.$1 ?? true) && !next.$1;
        if (idChanged || becameReady) {
          ref.invalidate(myXizmatlarProvider);
          ref.invalidate(feedProvider);
        }
      },
    );

    return child;
  }
}
