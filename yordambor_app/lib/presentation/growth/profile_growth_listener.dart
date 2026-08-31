import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/app_review_service.dart';
import 'package:yordambor/application/providers/growth_providers.dart';

/// Shows achievement celebration sheets when unlocks are detected app-wide.
class ProfileGrowthListener extends ConsumerWidget {
  const ProfileGrowthListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(providerGrowthProvider, (previous, next) {
      next.whenData((growth) async {
        if (growth == null) return;
        await showPendingAchievementCelebrations(
          context,
          ref,
          growth.unlockedIds,
        );
      });
    });

    return child;
  }
}
