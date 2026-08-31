import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/deep_link_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: AppMotion.slow,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: AppMotion.standard,
    );
    _fadeController.forward();
    unawaited(_navigateWhenReady());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _navigateWhenReady() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final deadline = DateTime.now().add(const Duration(seconds: 6));
    while (!ref.read(onboardingPrefsProvider).isLoaded ||
        ref.read(sessionProvider).isLoading) {
      if (DateTime.now().isAfter(deadline)) break;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
    }

    final session = ref.read(sessionProvider);
    final prefs = ref.read(onboardingPrefsProvider);
    final strings = ref.read(appStringsProvider);

    if (session.isAuthenticated) {
      final displayName = sessionGreetingName(session, strings.welcomeGuestName);
      ref.read(authWelcomeProvider.notifier).state = AuthWelcomeMessage(
        kind: AuthWelcomeKind.returningSession,
        displayName: displayName,
      );
      goAfterBootstrap(context, ref, '/home');
      return;
    }

    if (!prefs.welcomeSeen) {
      goAfterBootstrap(context, ref, '/welcome');
    } else {
      goAfterBootstrap(context, ref, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(_fadeAnimation),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const YordamBorLogo(
                    size: 140,
                    variant: YordamBorLogoVariant.onPrimary,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    strings.splashTagline,
                    textAlign: TextAlign.center,
                    style: AppTypography.headline.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
