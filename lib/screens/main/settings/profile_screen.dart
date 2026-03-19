import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_logger.dart';
import '../../../core/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/app_toast.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.headline),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
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
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: Center(
                      child: Text(
                        auth.userInitial,
                        style: AppTextStyles.headline.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'User',
                  style: AppTextStyles.headline.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            title: 'Account',
            children: [
              _buildInfoTile(
                icon: Icons.person_outline,
                label: 'Name',
                value: user?.name ?? 'Not set',
              ),
              const Divider(height: 1),
              _buildInfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user?.email ?? 'Not set',
              ),
              const Divider(height: 1),
              _buildInfoTile(
                icon: Icons.badge_outlined,
                label: 'User ID',
                value: user?.$id ?? 'Unknown',
              ),
            ],
          ),
          const SizedBox(height: 32),
          LimeButton(
            label: 'Sign Out',
            onPressed: () => _showSignOutConfirm(context),
            fullWidth: true,
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.oceanBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.oceanBlue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySecondary),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.cardTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Unknown';
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showSignOutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out', style: AppTextStyles.headline),
        content: Text('Are you sure you want to sign out?', style: AppTextStyles.bodySecondary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonSecondary),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  showToast(context, 'Logged out');
                  Navigator.pop(context);
                  context.go('/login');
                }
              } catch (e) {
                AppLogger.e('Logout error: $e');
                if (context.mounted) {
                  showToast(context, e.toString(), isError: true);
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.summerOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Sign Out', style: AppTextStyles.buttonPrimary),
          ),
        ],
      ),
    );
  }
}
