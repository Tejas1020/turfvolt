import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lime.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.electricBlue, size: 20),
            const SizedBox(height: 6),
          ],
          Text(value, style: AppTextStyles.statValue),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.micro.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
