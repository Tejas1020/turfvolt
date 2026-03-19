import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/main/home/home_screen.dart';
import '../screens/main/log/log_screen.dart';
import '../screens/main/main_shell.dart';
import '../screens/main/plans/plans_screen.dart';
import '../screens/main/plans/plan_create_workout_screen.dart';
import '../screens/main/reports/reports_screen.dart';
import '../screens/main/settings/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),

    // Auth routes
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),

    // Main app shell
    ShellRoute(
      builder: (c, s, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
        GoRoute(
          path: '/plans',
          builder: (c, s) => const PlansScreen(),
          routes: [
            GoRoute(
              path: 'create',
              builder: (c, s) => PlanCreateWorkoutScreen(),
            ),
            GoRoute(
              path: 'edit',
              builder: (c, s) {
                final planId = s.uri.queryParameters['planId'];
                return PlanCreateWorkoutScreen(planId: planId);
              },
            ),
          ],
        ),
        GoRoute(path: '/log', builder: (c, s) => const LogScreen()),
        GoRoute(path: '/reports', builder: (c, s) => const ReportsScreen()),
        GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      ],
    ),
  ],
);
