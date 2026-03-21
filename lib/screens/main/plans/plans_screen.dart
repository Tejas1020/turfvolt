import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/mesh_gradient_background.dart';
import '../../../widgets/shimmer.dart';
import '../../../models/plan_model.dart';
import 'plan_detail_screen.dart';
import 'plan_create_workout_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() {
    final auth = context.read<AuthProvider>();
    if (auth.user != null) {
      context.read<PlanProvider>().loadPlans(auth.user!.$id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansP = context.watch<PlanProvider>();
    final plans = plansP.plans;

    return MeshGradientBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText.coralOrange(
                        'MY PLANS',
                        style: AppTextStyles.gradientHero.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Build your perfect routine',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PlanCreateWorkoutScreen()),
                      );
                      _loadPlans();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.vibrantCoral.withAlpha(102),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
            // Plans List
            Expanded(
              child: plansP.loading
                  ? Shimmer(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: 5,
                        itemBuilder: (_, i) => ShimmerListItem(height: 100),
                      ),
                    )
                  : plans.isEmpty
                      ? _buildEmptyState()
                      : _buildPlansList(plans),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.vibrantCoral.withAlpha(77),
                      AppColors.electricOrange.withAlpha(77),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  size: 48,
                  color: AppColors.vibrantCoral,
                ),
              ),
              const SizedBox(height: 20),
              GradientText.coralOrange(
                'No Plans Yet',
                style: AppTextStyles.gradientHero.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first workout plan to get started',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: LimeButton(
                  label: 'Create Plan',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlanCreateWorkoutScreen()),
                    );
                  },
                  icon: Icons.add_rounded,
                  fullWidth: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansList(List<PlanModel> plans) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _buildPlanCard(plan);
      },
    );
  }

  Widget _buildPlanCard(PlanModel plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PlanDetailScreen(planId: plan.id)),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _InfoBadge(
                        icon: Icons.calendar_today_rounded,
                        label: '${plan.workoutDays.length} days',
                      ),
                      const SizedBox(width: 8),
                      _InfoBadge(
                        icon: Icons.fitness_center_rounded,
                        label: '${plan.totalExercises} exercises',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22),
              onPressed: () => _confirmDelete(plan),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(PlanModel plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Plan?',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete "${plan.name}"? This cannot be undone.',
                style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(ctx, true),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                'Delete',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<PlanProvider>().deletePlan(plan.id);
      showToast(context, 'Plan deleted');
      _loadPlans();
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
