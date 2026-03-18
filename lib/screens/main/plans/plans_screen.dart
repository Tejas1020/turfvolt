import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/constants.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/lime_button.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool creating = false;
  final _nameCtrl = TextEditingController();
  String planMuscle = muscleGroups.first;
  final Set<String> selectedExerciseIds = {};
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showToast(context, 'Plan name is required', isError: true);
      return;
    }
    if (selectedExerciseIds.isEmpty) {
      showToast(context, 'Select at least 1 exercise', isError: true);
      return;
    }
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      showToast(context, 'Please log in again', isError: true);
      return;
    }

    setState(() => _saving = true);
    try {
      await context.read<PlanProvider>().createPlan(
            userId: user.$id,
            name: name,
            muscleGroup: planMuscle,
            exerciseIds: selectedExerciseIds.toList(),
          );
      if (!mounted) return;
      setState(() {
        creating = false;
        _saving = false;
        _nameCtrl.clear();
        planMuscle = muscleGroups.first;
        selectedExerciseIds.clear();
      });
      showToast(context, 'Plan created successfully');
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showToast(context, e.toString(), isError: true);
    }
  }

  Future<void> _deletePlan(String planId, String planName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Plan?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to delete "$planName"?', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
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
      await context.read<PlanProvider>().deletePlan(planId);
      showToast(context, 'Plan deleted');
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plansP = context.watch<PlanProvider>();
    final exP = context.watch<ExerciseProvider>();
    final exercises = exP.exercises;

    final byMuscle = <String, List<ExerciseModel>>{};
    for (final m in muscleGroups) {
      byMuscle[m] = exercises.where((e) => e.muscle == m).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('WORKOUT PLANS', style: AppTextStyles.screenTitle.copyWith(fontSize: 22)),
                    const SizedBox(height: 4),
                    Text('Build your perfect routine', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
                LimeButton(
                  label: creating ? 'Cancel' : '+ New Plan',
                  size: ButtonSize.small,
                  onPressed: () => setState(() => creating = !creating),
                ),
              ],
            ),
          ),

          // Create Plan Card
          if (creating) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cardBg, AppColors.cardBg.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.lime.withOpacity(0.3), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lime.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lime.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.fitness_center, color: AppColors.lime, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Create New Plan',
                        style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('PLAN NAME', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameCtrl,
                    style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'e.g., Monday Push Day',
                      hintStyle: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
                      filled: true,
                      fillColor: AppColors.inputBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('TARGET MUSCLE', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: planMuscle,
                        isExpanded: true,
                        dropdownColor: AppColors.cardBg,
                        icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lime),
                        style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textPrimary),
                        items: muscleGroups.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                        onChanged: (v) => setState(() => planMuscle = v ?? muscleGroups.first),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text('EXERCISES', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.8)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lime.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('${selectedExerciseIds.length}', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.lime)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...muscleGroups.where((m) => (byMuscle[m]?.isNotEmpty ?? false)).map((m) {
                            final group = byMuscle[m]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: AppColors.muscleText(m),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        m.toUpperCase(),
                                        style: GoogleFonts.dmSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.muscleText(m),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: group.map((e) {
                                      final isSelected = selectedExerciseIds.contains(e.id);
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          if (isSelected) {
                                            selectedExerciseIds.remove(e.id);
                                          } else {
                                            selectedExerciseIds.add(e.id);
                                          }
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppColors.lime : AppColors.inputBg,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isSelected ? AppColors.lime : AppColors.borderDefault,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isSelected)
                                                const Icon(Icons.check_circle, size: 14, color: AppColors.appBg)
                                              else
                                                Icon(Icons.circle_outlined, size: 14, color: AppColors.textMuted),
                                              const SizedBox(width: 6),
                                              Text(
                                                e.name,
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 12,
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                  color: isSelected ? AppColors.appBg : AppColors.textMuted,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _savePlan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lime,
                        foregroundColor: AppColors.appBg,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.appBg),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save_alt, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Save Plan (${selectedExerciseIds.length} exercises)',
                                  style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Plans List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: plansP.loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
                    ),
                  )
                : plansP.plans.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.fitness_center_outlined, size: 48, color: AppColors.textDim),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Plans Yet',
                                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Create your first workout plan to get started',
                                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: 160,
                                    height: 44,
                                    child: ElevatedButton(
                                      onPressed: () => setState(() => creating = true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.lime,
                                        foregroundColor: AppColors.appBg,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, size: 18),
                                          const SizedBox(width: 6),
                                          Text('Create Plan', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 8),
                          ...plansP.plans.map((plan) {
                            final exs = plan.exerciseIds
                                .map((id) => exercises.where((e) => e.id == id).cast<ExerciseModel?>().firstOrNull)
                                .whereType<ExerciseModel>()
                                .toList();

                            final muscleColor = AppColors.muscleText(plan.muscleGroup);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.cardBg, AppColors.cardBg.withOpacity(0.9)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: muscleColor.withOpacity(0.3), width: 1),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    showToast(context, 'Plan: ${plan.name}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: muscleColor.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                _getMuscleIcon(plan.muscleGroup),
                                                color: muscleColor,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plan.name,
                                                    style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: muscleColor.withOpacity(0.2),
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          plan.muscleGroup.toUpperCase(),
                                                          style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w700, color: muscleColor, letterSpacing: 0.5),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '${exs.length} exercises',
                                                        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete_outline, color: AppColors.textDim, size: 20),
                                              onPressed: () => _deletePlan(plan.id, plan.name),
                                              tooltip: 'Delete plan',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: exs.take(5).map((e) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: AppColors.inputBg,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: AppColors.borderDefault, width: 0.5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    e.name,
                                                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        if (exs.length > 5) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            '+${exs.length - 5} more exercises',
                                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  IconData _getMuscleIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Upper Chest':
      case 'Lower Chest':
        return Icons.fitness_center;
      case 'Back':
        return Icons.accessibility;
      case 'Shoulders':
        return Icons.arrow_upward;
      case 'Biceps':
      case 'Triceps':
      case 'Forearms':
        return Icons.self_improvement;
      case 'Quads':
      case 'Hamstrings':
      case 'Glutes':
      case 'Calves':
        return Icons.directions_run;
      case 'Core':
        return Icons.favorite;
      default:
        return Icons.fitness_center;
    }
  }
}
