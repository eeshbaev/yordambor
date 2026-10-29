import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/growth/milestone_card.dart';

/// The greeting and the line under it (manual WL-01, WL-04): the time of
/// day and the first name, or "Welcome back" after a long break; then one
/// fact that matters now.
({String greeting, String fact}) homeGreeting(WidgetRef ref) {
  final strings = ref.watch(appStringsProvider);
  final session = ref.watch(sessionProvider);
  final launch = ref.watch(launchExperienceProvider);
  final welcome = ref.watch(authWelcomeProvider);
  final deals = ref.watch(homeDealsProvider);
  final mode = ref.watch(feedFilterProvider.select((f) => f.mode));
  final isNewMember = welcome?.kind == AuthWelcomeKind.newMember;

  final opening = isNewMember
      ? strings.greetingWelcomeNew
      : launch.welcomeBack
          ? strings.greetingWelcomeBack
          : greetingForHour(strings, DateTime.now().hour);
  final name = greetingFirstName(session);
  final greeting =
      name.isEmpty ? opening : strings.greetingWithName(opening, name);

  final String fact;
  if (isNewMember) {
    fact = strings.homeFactNewMember;
  } else if (deals.awaitingReply.isNotEmpty) {
    fact = strings.homeFactAwaitingReply(deals.awaitingReply.length);
  } else if (deals.inProgress.isNotEmpty) {
    fact = strings.homeFactInProgress(deals.inProgress.length);
  } else {
    fact = mode == FeedMode.yordamKerak
        ? strings.homeGreetingYordamKerak
        : strings.homeGreetingYordamBor;
  }
  return (greeting: greeting, fact: fact);
}

/// 05–11 morning, 12–17 afternoon, 18–22 evening, 23–04 a plain hello.
String greetingForHour(AppStrings strings, int hour) {
  if (hour >= 5 && hour < 12) return strings.greetingMorning;
  if (hour >= 12 && hour < 18) return strings.greetingAfternoon;
  if (hour >= 18 && hour < 23) return strings.greetingEvening;
  return strings.greetingNight;
}

/// The greeting and, when there is one, the next milestone. Scrolls away
/// under the bar, where the greeting folds into the title. The two ways to
/// start float over the feed instead, so they are never out of reach.
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.greetingKey});

  /// Measures the greeting so the bar knows when it has scrolled away.
  final GlobalKey greetingKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.ybColors;
    final (:greeting, :fact) = homeGreeting(ref);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GreetingEntrance(
            child: Column(
              key: greetingKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    greeting,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.largeTitle.copyWith(color: colors.ink),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.quick),
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.topLeft,
                    children: [...previous, ?current],
                  ),
                  child: Text(
                    fact,
                    key: ValueKey(fact),
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const MilestoneCard(),
        ],
      ),
    );
  }
}

/// The greeting arrives a beat after the page: once the launch hand-off is
/// over, it waits 200 ms, then fades in and rises 8 pt (manual WL-05). Once
/// per launch; still when motion is reduced.
class _GreetingEntrance extends StatefulWidget {
  const _GreetingEntrance({required this.child});

  final Widget child;

  @override
  State<_GreetingEntrance> createState() => _GreetingEntranceState();
}

class _GreetingEntranceState extends State<_GreetingEntrance>
    with SingleTickerProviderStateMixin {
  // 200 ms of stillness, then 300 ms of fade and rise.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (AppMotion.reduced(context)) {
      _controller.value = 1;
    } else if (LaunchHandoff.active.value) {
      LaunchHandoff.active.addListener(_onHandoffChanged);
    } else {
      _controller.forward();
    }
  }

  void _onHandoffChanged() {
    if (LaunchHandoff.active.value) return;
    LaunchHandoff.active.removeListener(_onHandoffChanged);
    if (mounted) _controller.forward();
  }

  @override
  void dispose() {
    LaunchHandoff.active.removeListener(_onHandoffChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, 8 * (1 - math.min(_progress.value, 1))),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
