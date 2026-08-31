import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/auth_welcome_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/favorites_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/presentation/auth/forgot_password_form.dart';
import 'package:yordambor/presentation/auth/login_form.dart';
import 'package:yordambor/presentation/auth/register_form.dart';

enum AuthSheetTab { login, register }

Future<bool> showAuthBottomSheet(
  BuildContext context,
  WidgetRef ref, {
  AuthSheetTab initialTab = AuthSheetTab.login,
  AuthContextType authContext = AuthContextType.generic,
}) async {
  final result = await showModalBottomSheet<bool>(
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: sheetHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
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
                      onBack: () => setState(() => _showForgotPassword = false),
                    )
                  else ...[
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: colors.textTertiary,
                      indicatorColor: AppColors.primary,
                      tabs: [
                        Tab(text: strings.login),
                        Tab(text: strings.register),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 440,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          LoginForm(
                            onSuccess: () => _onAuthSuccess(isRegister: false),
                            onError: _handleAuthError,
                            onForgotPassword: () =>
                                setState(() => _showForgotPassword = true),
                          ),
                          RegisterForm(
                            onSuccess: () => _onAuthSuccess(isRegister: true),
                            onError: _handleAuthError,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
        ),
      ),
    );
  }
}
