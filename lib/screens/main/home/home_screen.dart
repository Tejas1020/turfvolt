import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/plan_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/log_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../widgets/consistency_matrix.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/mesh_gradient_background.dart';
import '../../../widgets/skeleton_loader.dart';
import '../../../widgets/shimmer.dart';
import '../../../widgets/todays_workout_card.dart';
import '../../../widgets/weekly_progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;

    final auth = context.read<AuthProvider>();
    final user = auth.user;
    context.read<ExerciseProvider>().loadBuiltInExercises();
    if (user != null) {
      context.read<PlanProvider>().loadPlans(user.$id);
      context.read<LogProvider>().loadLogs(user.$id);
      context.read<ExerciseProvider>().loadCustomExercises(user.$id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logP = context.watch<LogProvider>();
    final planP = context.watch<PlanProvider>();
    final auth = context.watch<AuthProvider>();

    final today = DateTime.now();
    final todayWeekday = Weekday.values[today.weekday - 1];
    final dayName = DateFormat('EEEE').format(today);
    final userName = auth.user?.name?.split(' ').first ?? 'Fitness Warrior';

    final todaysPlans = planP.plans.where((plan) {
      return plan.workoutDays.any((day) => day.weekday == todayWeekday);
    }).toList();

    return MeshGradientBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (auth.user != null) {
              await context.read<PlanProvider>().loadPlans(auth.user!.$id);
              await context.read<LogProvider>().loadLogs(auth.user!.$id);
            }
          },
          color: AppColors.vibrantCoral,
          backgroundColor: AppColors.cardBg,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCompactHero(userName, dayName, logP.currentStreak),
                _buildTodaysWorkout(todaysPlans, dayName),
                _buildCompactStatsRow(logP),
                _buildConsistencySection(logP),
                _buildQuickActions(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHero(String userName, String dayName, int streak) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hey, ',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: userName,
                      style: AppTextStyles.gradientHero.copyWith(
                        fontSize: 32,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$dayName \u00b7 Let\'s crush it!',
                style: AppTextStyles.bodySecondary.copyWith(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          _StreakBadgeCompact(streak: streak),
        ],
      ),
    );
  }

  Widget _buildTodaysWorkout(List<PlanModel> plans, String dayName) {
    if (plans.isEmpty) {
      return _emptyWorkoutCard();
    }

    return Column(
      children: plans.take(1).map((plan) {
        return TodaysWorkoutCard(
          plan: plan,
          isToday: true,
          dayName: dayName,
        );
      }).toList(),
    );
  }

  Widget _buildCompactStatsRow(LogProvider logP) {
    final weeklyGoal = 5;
    final completedThisWeek = logP.logs
        .where((log) {
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final logDate = DateTime.parse(log.date);
          return logDate.isAfter(startOfWeek);
        })
        .length;
    final progress = completedThisWeek / weeklyGoal;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: GlassCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: logP.logs.isEmpty
                  ? const ShimmerStatCard()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.secondaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.local_fire_department_rounded,
                                color: AppColors.deepSpace,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'This Week',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$completedThisWeek/$weeklyGoal',
                                    style: AppTextStyles.statValue.copyWith(
                                      fontSize: 28,
                                    ),
                                  ),
                                  Text(
                                    'workouts done',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _MiniProgressRing(progress: progress),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GlassCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              child: logP.logs.isEmpty
                  ? const ShimmerStatCard()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.local_fire_department_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Streak',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            GradientText.coralOrange(
                              '${logP.currentStreak}',
                              style: AppTextStyles.statValue.copyWith(
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'days',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencySection(LogProvider logP) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GradientText.coralOrange(
                'Consistency',
                style: AppTextStyles.headline.copyWith(fontSize: 22),
              ),
              Text(
                'Last 16 weeks',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GlassCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: logP.logs.isEmpty
                ? Shimmer(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : ConsistencyMatrix(logs: logP.logs),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _QuickCard(
              icon: Icons.auto_stories_rounded,
              gradient: AppColors.secondaryGradient,
              title: 'Browse Library',
              subtitle: 'Explore exercises',
              onTap: () => context.go('/library'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickCard(
              icon: Icons.insights_rounded,
              gradient: AppColors.accentGradient,
              title: 'View Reports',
              subtitle: 'Track progress',
              onTap: () => context.go('/reports'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyWorkoutCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GradientBorderCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            GradientText.coralOrange(
              'Plan Your Day',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: 8),
            Text(
              'No workout scheduled for today.\nCreate a plan to get started!',
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: LimeButton(
                label: 'Create Workout',
                onPressed: () => context.go('/plans/create'),
                icon: Icons.add,
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakBadgeCompact extends StatelessWidget {
  final int streak;

  const _StreakBadgeCompact({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.vibrantCoral.withAlpha(77),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            '$streak',
            style: AppTextStyles.buttonPrimary.copyWith(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniProgressRing extends StatelessWidget {
  final double progress;

  const _MiniProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 5,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? AppColors.success : AppColors.vibrantCoral,
              ),
            ),
          ),
          Center(
            child: Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.micro.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppColors.deepSpace,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textDim,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
