import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/app_logger.dart';
import '../../core/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../widgets/glass_panel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    AppLogger.i('SplashScreen: checking session');
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      AppLogger.i('SplashScreen: session found -> /home');
      context.go('/home');
    } else {
      AppLogger.i('SplashScreen: no session -> /login');
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.appBg,
      body: Center(
        child: _SplashContent(),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final logo = AppTextStyles.appLogo.copyWith(fontSize: 48, letterSpacing: 4);
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      borderRadius: 24,
      blurSigma: 12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('TURFVOLT', style: logo),
          const SizedBox(height: 8),
          Text(
            'Track. Progress. Dominate.',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: AppColors.lime,
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}

