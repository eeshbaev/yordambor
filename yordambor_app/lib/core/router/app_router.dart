import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/domain/entities/create_xizmat_prefill.dart';
import 'package:yordambor/presentation/client_book/client_book_screen.dart';
import 'package:yordambor/presentation/earnings/earnings_screen.dart';
import 'package:yordambor/presentation/invite/join_screen.dart';
import 'package:yordambor/presentation/margin/margin_product_screen.dart';
import 'package:yordambor/presentation/margin/margin_screen.dart';
import 'package:yordambor/presentation/margin/margin_units_screen.dart';
import 'package:yordambor/presentation/calendar/schedule_calendar_screen.dart';
import 'package:yordambor/presentation/favorites/favorites_screen.dart';
import 'package:yordambor/presentation/home/home_screen.dart';
import 'package:yordambor/presentation/notifications/alert_settings_screen.dart';
import 'package:yordambor/presentation/notifications/notifications_screen.dart';
import 'package:yordambor/presentation/onboarding/onboarding_screen.dart';
import 'package:yordambor/presentation/onboarding/splash_screen.dart';
import 'package:yordambor/presentation/onboarding/verify_email_screen.dart';
import 'package:yordambor/presentation/onboarding/welcome_screen.dart';
import 'package:yordambor/presentation/auth/profile_setup_screen.dart';
import 'package:yordambor/presentation/auth/reset_password_screen.dart';
import 'package:yordambor/presentation/profile/blocked_users_screen.dart';
import 'package:yordambor/presentation/profile/profile_screen.dart';
import 'package:yordambor/presentation/profile/public_user_profile_screen.dart';
import 'package:yordambor/presentation/receipts/receipt_detail_screen.dart';
import 'package:yordambor/presentation/receipts/receipt_editor_screen.dart';
import 'package:yordambor/presentation/receipts/receipts_screen.dart';
import 'package:yordambor/presentation/reminders/reminder_settings_screen.dart';
import 'package:yordambor/presentation/search/search_screen.dart';
import 'package:yordambor/presentation/settings/legal_document_screen.dart';
import 'package:yordambor/presentation/settings/settings_screen.dart';
import 'package:yordambor/presentation/shell/main_shell.dart';
import 'package:yordambor/presentation/shell/shell_branch_container.dart';
import 'package:yordambor/presentation/shell/shell_tab_scaffold.dart';
import 'package:yordambor/presentation/shell/shell_tabs.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_archive_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_incoming_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_requests_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_screen.dart';
import 'package:yordambor/presentation/xizmat/my_xizmatlar_screen.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_screen.dart';
import 'package:yordambor/presentation/xizmat/manage_xizmat_screen.dart';
import 'package:yordambor/presentation/xizmat/xizmat_profile_screen.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/presentation/guides/guides_list_screen.dart';
import 'package:yordambor/presentation/support/help_screen.dart';
import 'package:yordambor/presentation/support/report_problem_screen.dart';
import 'package:yordambor/presentation/yordam_kerak/yordam_kerak_post_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The tabs fade up when they first appear (after the splash or the
/// welcome) and move like any other page while a screen covers them.
Widget _shellTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final route = ModalRoute.of(context);
  final covered = route is PageRoute
      ? Theme.of(context).pageTransitionsTheme.buildTransitions(
            route,
            context,
            kAlwaysCompleteAnimation,
            secondaryAnimation,
            child,
          )
      : child;
  final arriving = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
  return FadeTransition(
    opacity: arriving,
    child: SlideTransition(
      position: Tween(begin: const Offset(0, 0.015), end: Offset.zero)
          .animate(arriving),
      child: covered,
    ),
  );
}

/// Notifies go_router to re-run its redirect whenever the session changes.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<SessionState>(sessionProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final location = state.uri.path;

    // Skip the guard on screens that don't need a completed profile.
    const skipPaths = {
      '/splash',
      '/welcome',
      '/start',
      '/verify-email',
      '/reset-password',
      '/profile-setup',
    };
    if (skipPaths.any((p) => location.startsWith(p))) return null;

    // If the user is authenticated but hasn't completed their profile
    // (name or phone missing), redirect to /profile-setup.
    final session = _ref.read(sessionProvider);
    final user = session.user;
    final profile = session.profile;

    if (user != null && profile != null) {
      final nameBlank = profile.fullName.trim().isEmpty;
      final phoneBlank = profile.phone.trim().isEmpty;
      if (nameBlank || phoneBlank) return '/profile-setup';
    }

    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/start',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) =>
            ShellBranchContainer(
              currentIndex: navigationShell.currentIndex,
              children: children,
            ),
        pageBuilder: (context, state, navigationShell) {
          final still = AppMotion.reduced(context);
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: MainShell(navigationShell: navigationShell),
            transitionDuration:
                still ? AppMotion.reducedFade : const Duration(milliseconds: 360),
            reverseTransitionDuration: AppMotion.exit(
              const Duration(milliseconds: 360),
            ),
            transitionsBuilder: _shellTransition,
          );
        },
        branches: [
          StatefulShellBranch(
            preload: true,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: false,
            routes: [
              GoRoute(
                path: '/favorites',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TabScrollToTop(
                    index: 1,
                    child: ShellTabScaffold(child: FavoritesScreen()),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: false,
            routes: [
              GoRoute(
                path: '/calendar',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TabScrollToTop(
                    index: 2,
                    child: ShellTabScaffold(child: ScheduleCalendarScreen()),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: false,
            routes: [
              GoRoute(
                path: '/xizmatlarim',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TabScrollToTop(
                    index: 3,
                    child: ShellTabScaffold(child: MyXizmatlarScreen()),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            preload: false,
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TabScrollToTop(
                    index: 4,
                    child: ShellTabScaffold(child: ProfileScreen()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/client-book',
        builder: (context, state) => const ClientBookScreen(),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/receipts',
        builder: (context, state) => const ReceiptsScreen(),
      ),
      GoRoute(
        path: '/receipts/new',
        builder: (context, state) => const ReceiptEditorScreen(),
      ),
      GoRoute(
        path: '/receipts/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ReceiptDetailScreen(receiptId: id);
        },
      ),
      GoRoute(
        path: '/margin',
        builder: (context, state) => const MarginScreen(),
      ),
      GoRoute(
        path: '/margin/units',
        builder: (context, state) => const MarginUnitsScreen(),
      ),
      GoRoute(
        path: '/margin/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MarginProductScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/user/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PublicUserProfileScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/blocked-users',
        builder: (context, state) => const BlockedUsersScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notifications/alerts',
        builder: (context, state) => const AlertSettingsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/support/report',
        builder: (context, state) => const ReportProblemScreen(),
      ),
      GoRoute(
        path: '/guides',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) => GuidesListScreen(
            strings: ref.watch(appStringsProvider),
          ),
        ),
      ),
      GoRoute(
        path: '/guides/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return Consumer(
            builder: (context, ref, _) => GuideDetailScreen(
              slug: slug,
              strings: ref.watch(appStringsProvider),
            ),
          );
        },
      ),
      GoRoute(
        path: '/reminders',
        redirect: (context, state) =>
            state.uri.path == '/reminders' ? '/calendar' : null,
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const ReminderSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/legal/:type',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          return LegalDocumentScreen(type: type);
        },
      ),
      GoRoute(
        path: '/create-xizmat',
        builder: (context, state) {
          final prefill =
              CreateXizmatPrefill.fromQuery(state.uri.queryParameters);
          return CreateXizmatScreen(prefill: prefill.isEmpty ? null : prefill);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/join',
        builder: (context, state) => JoinScreen(
          prefill: CreateXizmatPrefill.fromQuery(state.uri.queryParameters),
        ),
      ),
      GoRoute(
        path: '/kelishuv/incoming',
        builder: (context, state) => const KelishuvIncomingScreen(),
      ),
      GoRoute(
        path: '/kelishuv/incoming/:xizmatId',
        builder: (context, state) {
          final xizmatId = state.pathParameters['xizmatId']!;
          final name = state.uri.queryParameters['name'];
          return KelishuvXizmatInboxScreen(
            xizmatId: xizmatId,
            xizmatName: name,
          );
        },
      ),
      GoRoute(
        path: '/kelishuv/requests',
        builder: (context, state) => const KelishuvRequestsScreen(),
      ),
      GoRoute(
        path: '/kelishuv/archive',
        builder: (context, state) => const KelishuvArchiveScreen(),
      ),
      GoRoute(
        path: '/kelishuv/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return KelishuvScreen(kelishuvId: id);
        },
      ),
      GoRoute(
        path: '/xizmat/:id/manage',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ManageXizmatScreen(xizmatId: id);
        },
      ),
      GoRoute(
        path: '/post/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return YordamKerakPostScreen(postId: id);
        },
      ),
      GoRoute(
        path: '/xizmat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return XizmatProfileScreen(xizmatId: id);
        },
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
    ],
  );
});
