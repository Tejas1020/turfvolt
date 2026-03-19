import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

/// Weekly progress bar with animated fill and comparison indicator
/// Shows progress toward weekly goal with visual momentum
class WeeklyProgressBar extends StatelessWidget {
  final int workoutsCompleted;
  final int weeklyGoal;
  final int lastWeekWorkouts;
  final Duration animationDuration;

  const WeeklyProgressBar({
    super.key,
    required this.workoutsCompleted,
    required this.weeklyGoal,
    required this.lastWeekWorkouts,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    final progress = workoutsCompleted / weeklyGoal;
    final difference = workoutsCompleted - lastWeekWorkouts;
    final isAhead = difference > 0;
    final isBehind = difference < 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Progress',
                style: AppTextStyles.headline.copyWith(fontSize: 18),
              ),
              if (difference != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAhead
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.coral.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isAhead ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: isAhead
                            ? AppColors.success
                            : AppColors.coral,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${difference.abs()} ${isAhead ? 'ahead' : 'behind'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isAhead
                              ? AppColors.success
                              : AppColors.coral,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 12,
                      color: AppColors.borderDark,
                    ),
                    AnimatedContainer(
                      duration: animationDuration,
                      curve: Curves.easeOut,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.summerOrange,
                            AppColors.sunshineYellow,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(progress >= 1.0 ? 8 : 0)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$workoutsCompleted / $weeklyGoal workouts',
                style: AppTextStyles.bodySecondary.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(progress * 100).clamp(0, 100).toInt()}%',
                style: AppTextStyles.statValue.copyWith(
                  fontSize: 16,
                  color: AppColors.summerOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mini progress indicator for compact displays
class MiniProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;
  final double width;

  const MiniProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.summerOrange,
    this.height = 8,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(
              color: AppColors.borderDark,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: width * progress.clamp(0.0, 1.0),
                height: height,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(progress >= 1.0 ? 4 : 0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
