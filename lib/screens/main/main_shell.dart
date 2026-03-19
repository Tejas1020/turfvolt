import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.92),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderDefault.withOpacity(0.5), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.summerOrange.withOpacity(0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TURFVOLT', style: AppTextStyles.appLogo),
            const SizedBox(height: 2),
            Text(formattedDate, style: AppTextStyles.secondary.copyWith(
              fontWeight: FontWeight.w500,
            )),
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
                    colors: [AppColors.summerOrange, AppColors.sunshineYellow],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.summerOrange.withOpacity(0.4),
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
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg.withOpacity(0.92),
              border: Border(
                top: BorderSide(color: AppColors.borderDefault.withOpacity(0.5), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.summerOrange.withOpacity(0.08),
                  offset: const Offset(0, -4),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (i) => context.go(_tabs[i]),
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.summerOrange,
              unselectedItemColor: AppColors.textMuted,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              iconSize: 22,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitness_center_outlined),
                  activeIcon: Icon(Icons.fitness_center_rounded),
                  label: 'Plans',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_outlined),
                  activeIcon: Icon(Icons.edit_rounded),
                  label: 'Log',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart_rounded),
                  label: 'Reports',
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
