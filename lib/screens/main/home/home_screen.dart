import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/plan_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/log_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../widgets/consistency_matrix.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/stat_card.dart';

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

    final plans = planP.plans.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's summary", style: AppTextStyles.label),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  value: '${logP.exercisesLoggedToday}',
                  label: 'Exercises',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: '${logP.setsDoneToday}',
                  label: 'Sets',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  value: '${logP.volumeToday.toStringAsFixed(0)}kg',
                  label: 'Volume',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _StreakBanner(streak: logP.currentStreak),
          const SizedBox(height: 16),
          ConsistencyMatrix(logs: logP.logs),
          const SizedBox(height: 16),
          Text('Your plans', style: AppTextStyles.label),
          const SizedBox(height: 8),
          if (planP.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
              ),
            )
          else if (plans.isEmpty)
            _EmptyPlansCard(
              onCreate: () => context.go('/plans'),
            )
          else
            ...plans.map((p) => _PlanCard(plan: p)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickCard(
                  icon: '📚',
                  title: 'Browse Library',
                  subtitle: 'All exercises',
                  onTap: () => context.go('/library'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickCard(
                  icon: '📊',
                  title: 'View Reports',
                  subtitle: 'Your progress',
                  onTap: () => context.go('/reports'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakBanner extends StatelessWidget {
  final int streak;
  const _StreakBanner({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.streakBgStart, AppColors.streakBgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumoHighlight.withOpacity(0.15),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: AppColors.neumoShadow.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('🔥 ', style: TextStyle(fontSize: 13)),
                  Text(
                    'Current streak',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Keep it up! Log today's workout.",
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.streakSubtitle),
              ),
            ],
          ),
          Text('$streak DAYS', style: AppTextStyles.streakNumber),
        ],
      ),
    );
  }
}

class _EmptyPlansCard extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyPlansCard({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neumoBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumoHighlight.withOpacity(0.2),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: AppColors.neumoShadow.withOpacity(0.35),
            offset: const Offset(2, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Text('No plans yet. Build your first plan!', style: AppTextStyles.body.copyWith(color: AppColors.textDim)),
          const SizedBox(height: 10),
          LimeButton(label: 'Create Plan', onPressed: onCreate),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanModel plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.neumoBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.neumoHighlight.withOpacity(0.18),
            offset: const Offset(-1, -1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: AppColors.neumoShadow.withOpacity(0.3),
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.name, style: AppTextStyles.exerciseName),
              const SizedBox(height: 2),
              Text('${plan.exerciseIds.length} exercises · ${plan.muscleGroup}', style: AppTextStyles.micro),
            ],
          ),
          ElevatedButton(
            onPressed: () => context.go('/log'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.appBg,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Start', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
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
          color: AppColors.neumoBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.neumoHighlight, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.neumoHighlight.withOpacity(0.18),
              offset: const Offset(-1, -1),
              blurRadius: 3,
            ),
            BoxShadow(
              color: AppColors.neumoShadow.withOpacity(0.3),
              offset: const Offset(1, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.micro),
          ],
        ),
      ),
    );
  }
}

