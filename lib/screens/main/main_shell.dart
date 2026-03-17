import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_toast.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = ['/home', '/library', '/plans', '/log', '/reports'];

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
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.neumoBg.withOpacity(0.88),
                border: Border(
                  bottom: BorderSide(color: AppColors.glassBorder, width: 1),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TURFVOLT', style: AppTextStyles.appLogo),
            Text(formattedDate, style: AppTextStyles.secondary),
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
                  if (context.mounted) showToast(context, e.toString(), isError: true);
                }
              },
              child: CircleAvatar(
                radius: 19,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.lime, AppColors.accentDark],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      userInitial,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appBg,
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
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.neumoBg.withOpacity(0.85),
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neumoShadow.withOpacity(0.2),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (i) => context.go(_tabs[i]),
              backgroundColor: Colors.transparent,
              elevation: 0,
          selectedItemColor: AppColors.lime,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Plans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined),
              activeIcon: Icon(Icons.edit),
              label: 'Log',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }
}

