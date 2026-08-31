import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/data/auth/auth_repository.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  int _cooldown = 0;
  Timer? _timer;
  bool _isSending = false;
  bool _isChecking = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _cooldown = 0);
      } else if (mounted) {
        setState(() => _cooldown -= 1);
      }
    });
  }

  String get _email {
    final session = ref.read(sessionProvider);
    return session.user?.email ??
        ref.read(pendingVerificationEmailProvider) ??
        '';
  }

  Future<void> _resend() async {
    if (_cooldown > 0 || _isSending) return;

    setState(() => _isSending = true);
    try {
      await ref.read(authRepositoryProvider).resendVerificationEmail(
            email: _email,
          );
      _startCooldown();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.read(appStringsProvider).resendEmail)),
        );
      }
    } on AuthFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _checkVerified() async {
    if (_isChecking || !Env.isConfigured) return;

    setState(() => _isChecking = true);
    try {
      await Supabase.instance.client.auth.refreshSession();
      await ref.read(sessionProvider.notifier).refreshProfile();
      final verified = ref.read(sessionProvider).isEmailVerified;
      if (verified && mounted) {
        ref.read(pendingVerificationEmailProvider.notifier).state = null;
        context.go('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(appStringsProvider).verifyEmailPending),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _openMail() async {
    final uri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final session = ref.watch(sessionProvider);
    final pendingEmail = ref.watch(pendingVerificationEmailProvider);
    final email = session.user?.email ?? pendingEmail ?? '';
    final colors = context.ybColors;

    ref.listen(sessionProvider, (previous, next) {
      if (next.isEmailVerified && context.mounted) {
        ref.read(pendingVerificationEmailProvider.notifier).state = null;
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: AppLayout.page(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                strings.verifyEmailTitle,
                style: AppTypography.title.copyWith(color: colors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                email.isNotEmpty
                    ? strings.verifyEmailBody(email)
                    : strings.verifyEmailBodyMissing,
                style: AppTypography.body.copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              YbPrimaryButton(
                label: strings.openMail,
                icon: Icons.mail_outline_rounded,
                onPressed: _openMail,
              ),
              const SizedBox(height: AppSpacing.sm),
              YbSecondaryButton(
                label: strings.verifyEmailCheck,
                onPressed: _isChecking ? null : _checkVerified,
              ),
              const SizedBox(height: AppSpacing.sm),
              YbSecondaryButton(
                label: _cooldown > 0
                    ? '${strings.resendEmail} (${_cooldown}s)'
                    : strings.resendEmail,
                onPressed: _cooldown > 0 || _isSending ? null : _resend,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text(strings.continueBrowsing),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
