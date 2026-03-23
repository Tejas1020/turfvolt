import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/app_logger.dart';
import '../../core/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_toast.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = ['/home', '/plans', '/log', '/reports', '/profile'];

  int _indexForLocation(String location) {
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d').format(DateTime.now());
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    final userInitial = context.watch<AuthProvider>().userInitial;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        backgroundColor: AppColors.appBg,
        elevation: 0,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TURFVOLT',
              style: TextStyle(
                fontFamily: 'Rosnoc',
                fontSize: 24,
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
                color: AppColors.lime,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formattedDate,
              style: AppTextStyles.secondary.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onLongPress: () async {
                try {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    showToast(context, 'Logged out');
                    context.go('/login');
                  }
                } catch (e) {
                  AppLogger.e('Logout error (long press): $e');
                  if (context.mounted) showToast(context, e.toString(), isError: true);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.lime, AppColors.limeDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lime.withAlpha(77),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 19,
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                        fontFamily: 'Rosnoc',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.buttonTextDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (i) => context.go(_tabs[i]),
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.lime,
              unselectedItemColor: AppColors.textGrayDark,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Rosnoc',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Rosnoc',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
              iconSize: 24,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center_outlined),
                  activeIcon: Icon(Icons.fitness_center_rounded),
                  label: 'Workouts',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_outlined),
                  activeIcon: Icon(Icons.edit_rounded),
                  label: 'Log',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart_rounded),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}