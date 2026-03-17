import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';

class MuscleChip extends StatelessWidget {
  final String muscle;

  const MuscleChip({
    super.key,
    required this.muscle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.muscleBg(muscle),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        muscle,
        style: AppTextStyles.chipText.copyWith(
          color: AppColors.muscleText(muscle),
        ),
      ),
    );
  }
}
