import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/app_toast.dart';
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

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WORKOUT PLANS', style: AppTextStyles.screenTitle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lime,
                    )),
                    const SizedBox(height: 4),
                    Text('Create and manage your workout routines',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                  ],
                ),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.summerOrange, AppColors.sunshineYellow],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.summerOrange.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
        ),

        // Plans List
        Expanded(
          child: plansP.loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
                )
              : plans.isEmpty
                  ? _buildEmptyState()
                  : _buildPlansList(plans),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderDefault.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.fitness_center_outlined, size: 64, color: AppColors.textDim),
                  const SizedBox(height: 20),
                  Text(
                    'No Plans Yet',
                    style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first workout plan to get started',
                    style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PlanCreateWorkoutScreen()),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text('Create & Start', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lime,
                        foregroundColor: AppColors.appBg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardBg, AppColors.cardBg.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.lime.withOpacity(0.06),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlanDetailScreen(planId: plan.id)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.lime.withOpacity(0.2), AppColors.lime.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lime.withOpacity(0.3)),
              ),
              child: Icon(Icons.fitness_center_rounded, color: AppColors.lime, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlanDetailScreen(planId: plan.id)),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.workoutDays.length} days • ${plan.totalExercises} exercises',
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.coral.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.coral, size: 22),
              onPressed: () => _confirmDelete(plan),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(PlanModel plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Plan?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: Text(
          'Are you sure you want to delete "${plan.name}"? This cannot be undone.',
          style: GoogleFonts.dmSans(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
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
