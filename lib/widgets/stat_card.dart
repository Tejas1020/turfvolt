import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.neumoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumoHighlight.withOpacity(0.2),
            offset: const Offset(-1, -1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: AppColors.neumoShadow.withOpacity(0.35),
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppTextStyles.statValue),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.micro),
        ],
      ),
    );
  }
}
