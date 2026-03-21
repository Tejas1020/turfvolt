import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

/// Premium stat card with gradient accent for Dribbble aesthetic
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Gradient? gradient;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: gradient ?? AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.deepSpace,
              size: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              fontSize: 26,
              letterSpacing: 0.5,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
