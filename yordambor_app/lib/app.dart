import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/router/app_router.dart';
import 'package:yordambor/core/theme/app_theme.dart';
import 'package:yordambor/l10n/app_localizations.dart';
import 'package:yordambor/presentation/auth/auth_catalog_sync_listener.dart';
import 'package:yordambor/presentation/auth/auth_recovery_listener.dart';
import 'package:yordambor/presentation/growth/profile_growth_listener.dart';
import 'package:yordambor/presentation/notifications/app_notification_tap_listener.dart';
import 'package:yordambor/presentation/notifications/notifications_realtime_listener.dart';
import 'package:yordambor/presentation/shared/deep_link_listener.dart';
import 'package:yordambor/presentation/shared/reminder_tap_listener.dart';
import 'package:yordambor/presentation/shared/system_ui_theme_sync.dart';

class YordamBorApp extends ConsumerWidget {
  const YordamBorApp({super.key});

  Locale _localeForLanguage(String code) => switch (code) {
        'ru' => const Locale('ru'),
        'en' => const Locale('en'),
        'zh' => const Locale('zh'),
        _ => const Locale('uz'),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefs = ref.watch(onboardingPrefsProvider);

    return AuthCatalogSyncListener(
      child: AuthRecoveryListener(
        child: DeepLinkListener(
          child: ReminderTapListener(
            child: MaterialApp.router(
            title: 'YordamBor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: prefs.themeMode,
            locale: _localeForLanguage(prefs.language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: router,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              // The person's text size is honoured up to 200 % (manual
              // T-01); layouts grow and reflow rather than clip.
              final textScaler = media.textScaler.clamp(
                minScaleFactor: 0.9,
                maxScaleFactor: 2,
              );

              return NotificationsRealtimeListener(
                child: AppNotificationTapListener(
                  child: ProfileGrowthListener(
                    child: MediaQuery(
                      data: media.copyWith(textScaler: textScaler),
                      child: SystemUiThemeSync(
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      ),
    );
  }
}
