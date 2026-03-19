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
import '../../../widgets/animated_streak_counter.dart';
import '../../../widgets/consistency_matrix.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/weekly_progress_bar.dart';
import '../../../widgets/challenge_card.dart';
import '../../../widgets/activity_feed_item.dart';
import '../../../widgets/skeleton_loader.dart';
import '../../../widgets/todays_workout_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _loaded = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
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

    // Get today's plans
    final todaysPlans = planP.plans.where((plan) {
      return plan.workoutDays.any((day) => day.weekday == todayWeekday);
    }).toList();

    final displayPlans = todaysPlans.isNotEmpty ? todaysPlans : planP.plans;

    return RefreshIndicator(
      onRefresh: () async {
        if (auth.user != null) {
          await context.read<PlanProvider>().loadPlans(auth.user!.$id);
          await context.read<LogProvider>().loadLogs(auth.user!.$id);
        }
      },
      color: AppColors.summerOrange,
      backgroundColor: AppColors.cardBg,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(userName, dayName, todayWeekday),
              _buildTodaysWorkout(displayPlans, todaysPlans.isNotEmpty, dayName),
              _buildWeeklyProgress(logP),
              _buildChallengesSection(),
              _buildActivityFeed(),
              _buildConsistencySection(logP),
              _buildQuickActions(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(String userName, String dayName, Weekday todayWeekday) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBg.withOpacity(0.8),
            AppColors.appBg,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName!',
                style: AppTextStyles.displayHero.copyWith(
                  fontSize: 28,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$dayName • Ready to crush it?',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 15),
              ),
            ],
          ),
          StreakBadge(streak: context.watch<LogProvider>().currentStreak),
        ],
      ),
    );
  }

  Widget _buildTodaysWorkout(List<PlanModel> plans, bool isToday, String dayName) {
    if (plans.isEmpty) {
      return _emptyWorkoutCard();
    }

    return Column(
      children: plans.take(1).map((plan) {
        return TodaysWorkoutCard(
          plan: plan,
          isToday: isToday,
          dayName: dayName,
        );
      }).toList(),
    );
  }

  Widget _buildWeeklyProgress(LogProvider logP) {
    final weeklyGoal = 5;
    final completedThisWeek = logP.logs
        .where((log) {
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final logDate = DateTime.parse(log.date);
          return logDate.isAfter(startOfWeek);
        })
        .length;
    final lastWeekWorkouts = 3; // Would be calculated from actual data

    return WeeklyProgressBar(
      workoutsCompleted: completedThisWeek,
      weeklyGoal: weeklyGoal,
      lastWeekWorkouts: lastWeekWorkouts,
    );
  }

  Widget _buildChallengesSection() {
    final now = DateTime.now();
    final challenges = [
      ChallengeCard(
        title: '30-Day Strength',
        description: 'Complete 30 workouts this month',
        currentProgress: 12,
        target: 30,
        endDate: now.add(const Duration(days: 18)),
        icon: Icons.fitness_center,
        accentColor: AppColors.summerOrange,
      ),
      ChallengeCard(
        title: 'Cardio Blitz',
        description: '5 cardio sessions this week',
        currentProgress: 2,
        target: 5,
        endDate: now.add(Duration(days: 4 - now.weekday)),
        icon: Icons.favorite,
        accentColor: AppColors.oceanBlue,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Active Challenges', style: AppTextStyles.headline),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ChallengeList(challenges: challenges),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    final activities = SyntheticActivityGenerator.generateFeed(count: 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Feed', style: AppTextStyles.headline),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.summerOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'LIVE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.summerOrange,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ActivityFeed(items: activities),
        ],
      ),
    );
  }

  Widget _buildConsistencySection(LogProvider logP) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Consistency', style: AppTextStyles.headline),
              Text('Last 16 weeks', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
          ConsistencyMatrix(logs: logP.logs),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _QuickCard(
              icon: Icons.auto_stories_outlined,
              iconColor: AppColors.oceanBlue,
              iconBg: AppColors.oceanBlue.withOpacity(0.15),
              title: 'Browse Library',
              subtitle: 'All exercises',
              onTap: () => context.go('/library'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuickCard(
              icon: Icons.insights_outlined,
              iconColor: AppColors.success,
              iconBg: AppColors.success.withOpacity(0.15),
              title: 'View Reports',
              subtitle: 'Your progress',
              onTap: () => context.go('/reports'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyWorkoutCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardBg,
            AppColors.cardBg.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          SkeletonShapes.avatar(size: 60),
          const SizedBox(height: 16),
          Text(
            'No workout scheduled',
            style: AppTextStyles.headline,
          ),
          const SizedBox(height: 6),
          Text(
            'Create a plan or browse exercises to get started',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: LimeButton(
              label: 'Create & Start Workout',
              onPressed: () => context.go('/plans/create'),
              icon: Icons.add,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}

// Quick action card
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
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
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.micro,
            ),
          ],
        ),
      ),
    );
  }
}
