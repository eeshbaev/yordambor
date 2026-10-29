import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/presentation/auth/forgot_password_form.dart';
import 'package:yordambor/presentation/auth/login_form.dart';
import 'package:yordambor/presentation/auth/register_form.dart';
import 'package:yordambor/presentation/auth/social_auth_buttons.dart';

enum AuthSheetTab { login, register }

Future<bool> showAuthBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  AuthSheetTab initialTab = AuthSheetTab.login,
  AuthContextType authContext = AuthContextType.generic,
}) async {
  final result = await showModalBottomSheet<bool>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => AuthBottomSheet(
      initialTab: initialTab,
      authContext: authContext,
    ),
  );
  return result ?? false;
}

class AuthBottomSheet extends ConsumerStatefulWidget {
  const AuthBottomSheet({
    super.key,
    required this.initialTab,
    required this.authContext,
  });

  final AuthSheetTab initialTab;
  final AuthContextType authContext;

  @override
  ConsumerState<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends ConsumerState<AuthBottomSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  var _showForgotPassword = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == AuthSheetTab.register ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onAuthSuccess({required bool isRegister}) async {
    await ref.read(onboardingPrefsProvider.notifier).markWelcomeSeen();
    await ref.read(sessionProvider.notifier).refreshProfile();

    if (!mounted) return;

    final session = ref.read(sessionProvider);
    final strings = ref.read(appStringsProvider);
    final displayName = sessionGreetingName(session, strings.welcomeGuestName);

    ref.read(authWelcomeProvider.notifier).state = AuthWelcomeMessage(
      kind: isRegister
          ? AuthWelcomeKind.newMember
          : AuthWelcomeKind.returningLogin,
      displayName: displayName,
    );

    await ref.read(favoritesProvider.notifier).syncToAccountAfterLogin();

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  void _handleAuthError(AuthFailure error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  }

  void _handleSocialError(String message) {
    _handleAuthError(AuthFailure(message));
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    // Keyboard inset so content shifts up when keyboard is open
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header: title + social buttons + tab bar ──────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      strings.authContextSubtitle(widget.authContext),
                      style: AppTypography.title.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_showForgotPassword)
                      ForgotPasswordForm(
                        onBack: () =>
                            setState(() => _showForgotPassword = false),
                      )
                    else
                      SocialAuthButtons(
                        dividerLabel: 'yoki email bilan',
                        onSuccess: () => _onAuthSuccess(isRegister: false),
                        onError: _handleSocialError,
                      ),
                  ],
                ),
              ),
              if (!_showForgotPassword) ...[
                // ── Tab bar ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: context.ybColors.teal,
                    unselectedLabelColor: colors.textTertiary,
                    indicatorColor: context.ybColors.teal,
                    tabs: [
                      Tab(text: strings.login),
                      Tab(text: strings.register),
                    ],
                  ),
                ),
                // ── Tab forms — fill remaining space and scroll internally ─
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: LoginForm(
                          onSuccess: () => _onAuthSuccess(isRegister: false),
                          onError: _handleAuthError,
                          onForgotPassword: () =>
                              setState(() => _showForgotPassword = true),
                        ),
                      ),
                      RegisterForm(
                        onSuccess: () => _onAuthSuccess(isRegister: true),
                        onError: _handleAuthError,
                      ),
                    ],
                  ),
                ),
              ],
              // ── "Keyinroq" footer ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(strings.later),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
