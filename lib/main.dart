import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_logger.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/log_provider.dart';
import 'providers/plan_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.i('main() start');

  final authProvider = AuthProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => PlanProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: MaterialApp.router(
        title: 'TurfVolt',
        theme: appTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );

  // Don't block first frame on network/auth checks.
  // SplashScreen will route based on session status.
  // Still initialize provider in background for userInitial, etc.
  Future<void>(() async {
    AppLogger.i('AuthProvider.init() (background) start');
    await authProvider.init();
    AppLogger.i('AuthProvider.init() (background) done');
  });
}
