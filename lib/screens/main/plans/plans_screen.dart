import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/constants.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/muscle_chip.dart';
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
      showToast(context, 'Plan saved');
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MY PLANS', style: AppTextStyles.screenTitle),
              LimeButton(
                label: creating ? 'Close' : '+ New Plan',
                size: ButtonSize.small,
                onPressed: () => setState(() => creating = !creating),
              ),
            ],
          ),
          if (creating) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create new plan',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(hintText: 'Plan name (e.g. Monday Push)'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: planMuscle,
                    dropdownColor: AppColors.cardBg,
                    decoration: const InputDecoration(),
                    items: muscleGroups.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (v) => setState(() => planMuscle = v ?? muscleGroups.first),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Select exercises (${selectedExerciseIds.length} selected)',
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 8),
                  ...muscleGroups.where((m) => (byMuscle[m]?.isNotEmpty ?? false)).map((m) {
                    final group = byMuscle[m]!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.muscleText(m),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ...group.map((e) {
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
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.selectedBg : AppColors.inputBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected ? AppColors.lime : AppColors.cardBg,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? AppColors.lime : AppColors.cardBg,
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check, size: 12, color: AppColors.appBg)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      e.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _savePlan,
                      child: Text(_saving
                          ? 'Saving...'
                          : 'Save Plan (${selectedExerciseIds.length} exercises)'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (plansP.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
              ),
            )
          else if (plansP.plans.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('No plans yet.', style: AppTextStyles.secondary),
            )
          else
            ...plansP.plans.map((plan) {
              final exs = plan.exerciseIds
                  .map((id) => exercises.where((e) => e.id == id).cast<ExerciseModel?>().firstOrNull)
                  .whereType<ExerciseModel>()
                  .toList();

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(plan.name, style: AppTextStyles.cardTitle),
                        MuscleChip(muscle: plan.muscleGroup),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: exs
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.inputBg,
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(color: AppColors.borderDefault, width: 0.5),
                              ),
                              child: Text(e.name, style: AppTextStyles.micro),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text('${exs.length} exercises', style: AppTextStyles.micro),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

