import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/presentation/client_book/client_book_screen.dart';
import 'package:yordambor/presentation/earnings/earnings_screen.dart';
import 'package:yordambor/presentation/favorites/favorites_screen.dart';
import 'package:yordambor/presentation/home/home_screen.dart';
import 'package:yordambor/presentation/notifications/notifications_screen.dart';
import 'package:yordambor/presentation/onboarding/splash_screen.dart';
import 'package:yordambor/presentation/onboarding/verify_email_screen.dart';
import 'package:yordambor/presentation/onboarding/welcome_screen.dart';
import 'package:yordambor/presentation/auth/reset_password_screen.dart';
import 'package:yordambor/presentation/profile/blocked_users_screen.dart';
import 'package:yordambor/presentation/profile/profile_screen.dart';
import 'package:yordambor/presentation/profile/public_user_profile_screen.dart';
import 'package:yordambor/presentation/reminders/reminder_settings_screen.dart';
import 'package:yordambor/presentation/reminders/reminders_screen.dart';
import 'package:yordambor/presentation/settings/legal_document_screen.dart';
import 'package:yordambor/presentation/settings/settings_screen.dart';
import 'package:yordambor/presentation/shell/main_shell.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_archive_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_incoming_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_requests_screen.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_screen.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_screen.dart';
import 'package:yordambor/presentation/xizmat/manage_xizmat_screen.dart';
import 'package:yordambor/presentation/xizmat/xizmat_profile_screen.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/presentation/guides/guides_list_screen.dart';
import 'package:yordambor/presentation/support/help_screen.dart';
import 'package:yordambor/presentation/support/report_problem_screen.dart';
import 'package:yordambor/presentation/yordam_kerak/yordam_kerak_post_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
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
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
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
                  child: FavoritesScreen(),
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
                  child: ProfileScreen(),
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
        builder: (context, state) => const RemindersScreen(),
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
        builder: (context, state) => const CreateXizmatScreen(),
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
    ],
  );
});
