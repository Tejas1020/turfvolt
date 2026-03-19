import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/plan_model.dart';

/// Today's Workout Card - The centerpiece of the home screen
/// Prominent, elevated design with immediate CTA
class TodaysWorkoutCard extends StatelessWidget {
  final PlanModel plan;
  final bool isToday;
  final String dayName;

  const TodaysWorkoutCard({
    super.key,
    required this.plan,
    required this.isToday,
    required this.dayName,
  });

  @override
  Widget build(BuildContext context) {
    final workoutDay = plan.workoutDays.firstWhere(
      (d) => d.weekday.name == dayName.toLowerCase(),
      orElse: () => plan.workoutDays.first,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBg,
            AppColors.cardBg.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isToday ? AppColors.summerOrange.withOpacity(0.5) : AppColors.borderDefault,
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? AppColors.summerOrange.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
            blurRadius: isToday ? 20 : 12,
            offset: const Offset(0, 8),
            spreadRadius: isToday ? 0 : 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient border top
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isToday
                    ? [
                        AppColors.summerOrange.withOpacity(0.15),
                        AppColors.sunshineYellow.withOpacity(0.08),
                      ]
                    : [
                        AppColors.oceanBlue.withOpacity(0.1),
                        AppColors.secondary.withOpacity(0.05),
                      ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isToday
                          ? [AppColors.summerOrange, AppColors.sunshineYellow]
                          : [AppColors.oceanBlue, AppColors.skyBlue],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isToday ? AppColors.summerOrange : AppColors.oceanBlue)
                            .withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isToday) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.summerOrange, AppColors.sunshineYellow],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'TODAY',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            plan.name,
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.fitness_center, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${workoutDay.exercises.length} exercises',
                            style: AppTextStyles.caption,
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '~${workoutDay.estimatedDuration} min',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Exercise preview
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exercises',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: workoutDay.exercises.take(5).map((ex) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.muscleText(ex.muscleGroup).withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.muscleText(ex.muscleGroup),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            ex.exerciseName.length > 18
                                ? '${ex.exerciseName.substring(0, 18)}...'
                                : ex.exerciseName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.muscleText(ex.muscleGroup),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // CTA Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/log'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isToday ? AppColors.summerOrange : AppColors.oceanBlue,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: (isToday ? AppColors.summerOrange : AppColors.oceanBlue)
                      .withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: AppTextStyles.buttonPrimary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isToday ? Icons.play_arrow_rounded : Icons.schedule,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isToday ? 'Start Workout' : 'Schedule for $dayName',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
