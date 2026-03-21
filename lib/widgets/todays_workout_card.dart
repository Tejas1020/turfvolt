import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../models/plan_model.dart';

/// Today's Workout Card - Premium Dribbble-inspired design
/// Vibrant gradient, glass effect, prominent CTA
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
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isToday
              ? [
                  AppColors.cardBg,
                  const Color(0xFF1E1A2E),
                ]
              : [
                  AppColors.cardBg,
                  const Color(0xFF181825),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isToday
              ? AppColors.glassBorder
              : AppColors.borderDefault,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? AppColors.vibrantCoral.withAlpha(51)
                : Colors.black.withAlpha(51),
            blurRadius: isToday ? 32 : 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Glass header with gradient accent
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isToday
                    ? [
                        AppColors.vibrantCoral.withAlpha(26),
                        AppColors.electricOrange.withAlpha(13),
                      ]
                    : [
                        AppColors.glassFill,
                        AppColors.glassFill.withAlpha(128),
                      ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Animated gradient icon container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: isToday
                        ? AppColors.primaryGradient
                        : const LinearGradient(
                            colors: [AppColors.softLavender, AppColors.lavenderLight],
                          ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (isToday ? AppColors.vibrantCoral : AppColors.softLavender)
                            .withAlpha(102),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      if (isToday)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.cardBg,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.vibrantCoral.withAlpha(77),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Text(
                                'TODAY',
                                style: AppTextStyles.micro.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              plan.name,
                              style: AppTextStyles.gradientHero.copyWith(
                                fontSize: 22,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.fitness_center_rounded,
                            label: '${workoutDay.exercises.length} exercises',
                          ),
                          const SizedBox(width: 12),
                          _InfoChip(
                            icon: Icons.timer_rounded,
                            label: '~${workoutDay.estimatedDuration} min',
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
                  'EXERCISES',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textDim,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: workoutDay.exercises.take(5).map((ex) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.muscleBg(ex.muscleGroup),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.muscleText(ex.muscleGroup).withAlpha(77),
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
                          const SizedBox(width: 8),
                          Text(
                            ex.exerciseName.length > 20
                                ? '${ex.exerciseName.substring(0, 20)}...'
                                : ex.exerciseName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
          // CTA Button with gradient
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: isToday ? AppColors.primaryGradient : null,
                color: isToday ? null : AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: isToday
                    ? null
                    : Border.all(color: AppColors.border),
                boxShadow: isToday
                    ? [
                        BoxShadow(
                          color: AppColors.vibrantCoral.withAlpha(102),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go('/log'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isToday ? Icons.play_arrow_rounded : Icons.schedule_rounded,
                          size: 24,
                          color: isToday ? Colors.white : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isToday ? 'Start Workout' : 'Schedule for $dayName',
                          style: AppTextStyles.buttonPrimary.copyWith(
                            color: isToday ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
