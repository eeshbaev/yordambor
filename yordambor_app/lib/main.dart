import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yordambor/app.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/core/supabase/supabase_auth_errors.dart';
import 'package:yordambor/core/supabase/supabase_bootstrap.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      AppFonts.registerLicenses();

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      await Hive.initFlutter();
      SupabaseBootstrap.installGlobalErrorHandlers();
      await SupabaseBootstrap.initialize();

      runApp(const ProviderScope(child: YordamBorApp()));

      unawaited(LocalNotificationService.instance.initialize());
    },
    (error, stack) {
      if (isSupabaseAuthNetworkError(error)) {
        unawaited(signOutSupabaseIfConfigured());
        if (kDebugMode) {
          debugPrint('Supabase auth network error (zone): $error');
        }
        return;
      }

      FlutterError.presentError(
        FlutterErrorDetails(exception: error, stack: stack),
      );
    },
  );
}
