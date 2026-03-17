import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import 'muscle_chip.dart';

class ExerciseRow extends StatelessWidget {
  final String name;
  final String muscle;
  final String desc;
  final String icon;
  final bool isCustom;
  final VoidCallback? onTap;

  const ExerciseRow({
    super.key,
    required this.name,
    required this.muscle,
    required this.desc,
    required this.icon,
    this.isCustom = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDefault, width: 0.5),
        ),
        child: Row(
          children: [
            // Icon square
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.muscleBg(muscle),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: AppTextStyles.exerciseName),
                      if (isCustom) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.customBadgeBg,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            'custom',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.lime,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(desc, style: AppTextStyles.micro),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Muscle chip
            MuscleChip(muscle: muscle),
          ],
        ),
      ),
    );
  }
}
