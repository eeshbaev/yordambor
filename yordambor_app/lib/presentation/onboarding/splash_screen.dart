import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/deep_link_provider.dart';
import 'package:yordambor/application/providers/experience_providers.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';

/// Size of the mark on the native launch screen and here, so the hand-off
/// shows no jump.
const double _kLaunchMarkSize = 128;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // The logo breathes only while real start-up work is still running.
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _breath, curve: Curves.easeInOut),
    );
    unawaited(_navigateWhenReady());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _breath.stop();
    } else if (!_breath.isAnimating) {
      _breath.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  /// No artificial delay (manual LG-01): leave as soon as preferences, the
  /// session and this launch's first-minute memory are ready.
  Future<void> _navigateWhenReady() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    // Read now, before onboarding can mark the welcome as seen.
    ref.read(launchExperienceProvider);

    final deadline = DateTime.now().add(const Duration(seconds: 6));
    while (!ref.read(onboardingPrefsProvider).isLoaded ||
        ref.read(sessionProvider).isLoading ||
        !ref.read(launchExperienceProvider).isLoaded) {
      if (DateTime.now().isAfter(deadline)) break;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
    }

    final session = ref.read(sessionProvider);
    final prefs = ref.read(onboardingPrefsProvider);

    // No "welcome back" banner on every launch (manual WL-06): the home
    // greeting says hello instead.
    final destination =
        session.isAuthenticated || prefs.welcomeSeen ? '/home' : '/welcome';

    if (!AppMotion.reduced(context)) _startHandoff();
    goAfterBootstrap(context, ref, destination);
  }

  /// The launch mark zooms through as the next page fades up beneath it
  /// (design direction 9A). It runs above the routes, so the splash can be
  /// replaced at once.
  void _startHandoff() {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    final background = context.ybColors.surface;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _LaunchHandoff(
        background: background,
        onDone: () {
          LaunchHandoff.active.value = false;
          if (entry.mounted) entry.remove();
        },
      ),
    );
    LaunchHandoff.active.value = true;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    // Same background and centred mark as the native launch screen, so the
    // hand-off shows no flash (manual LG-04, LG-07). No text on launch.
    return Scaffold(
      backgroundColor: context.ybColors.surface,
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: const YordamBorLogoMark(size: _kLaunchMarkSize, shake: false),
        ),
      ),
    );
  }
}

/// A copy of the splash drawn over everything: the mark grows past the
/// viewer and fades, then the page colour lifts off the new screen.
class _LaunchHandoff extends StatefulWidget {
  const _LaunchHandoff({required this.background, required this.onDone});

  final Color background;
  final VoidCallback onDone;

  @override
  State<_LaunchHandoff> createState() => _LaunchHandoffState();
}

class _LaunchHandoffState extends State<_LaunchHandoff>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );

  late final Animation<double> _markScale = Tween<double>(begin: 1, end: 2.4)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
  late final Animation<double> _markOpacity = Tween<double>(begin: 1, end: 0)
      .animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.15, 0.75, curve: Curves.easeIn),
  ));
  late final Animation<double> _pageOpacity = Tween<double>(begin: 1, end: 0)
      .animate(CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.25, 1, curve: Curves.easeOut),
  ));

  @override
  void initState() {
    super.initState();
    // Only a finished hand-off removes itself; one cut short by the app
    // closing is simply dropped.
    _controller.forward().then((_) => widget.onDone());
  }

  @override
  void dispose() {
    _controller.dispose();
    LaunchHandoff.active.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _pageOpacity,
        child: ColoredBox(
          color: widget.background,
          child: Center(
            child: FadeTransition(
              opacity: _markOpacity,
              child: ScaleTransition(
                scale: _markScale,
                child: const YordamBorLogoMark(size: _kLaunchMarkSize, shake: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
