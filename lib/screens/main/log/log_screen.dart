import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/exercise_model.dart';
import '../../../models/plan_model.dart';
import '../../../models/set_entry_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/log_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/muscle_chip.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String step = 'select'; // select -> log -> done
  DateTime selectedDate = DateTime.now();

  PlanModel? selectedPlan;
  int activeExerciseIndex = 0;

  final _notesCtrl = TextEditingController();

  // exerciseId -> drafts
  final Map<String, List<_SetDraft>> _drafts = {};

  @override
  void dispose() {
    _notesCtrl.dispose();
    for (final sets in _drafts.values) {
      for (final s in sets) {
        s.dispose();
      }
    }
    super.dispose();
  }

  void _initDrafts(List<ExerciseModel> exercises) {
    _drafts.clear();
    for (final e in exercises) {
      _drafts[e.id] = List.generate(
        3,
        (_) => _SetDraft(reps: '10', weight: ''),
      );
    }
  }

  bool _exerciseHasDoneSet(String exerciseId) {
    final sets = _drafts[exerciseId] ?? const [];
    return sets.any((s) => s.done);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.lime,
                  surface: AppColors.cardBg,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return;
    setState(() => selectedDate = picked);
  }

  Future<void> _finishAndSave() async {
    final user = context.read<AuthProvider>().user;
    final plan = selectedPlan;
    if (user == null || plan == null) {
      showToast(context, 'Please log in again', isError: true);
      return;
    }

    final exP = context.read<ExerciseProvider>();
    // Collect all unique exercises from all workout days
    final exerciseIds = plan.exerciseIds;
    final planExercises = exerciseIds
        .map((id) => exP.exercises.where((e) => e.id == id).cast<ExerciseModel?>().firstOrNull)
        .whereType<ExerciseModel>()
        .toList();

    final dateStr = selectedDate.toIso8601String().split('T')[0];
    final notes = _notesCtrl.text.trim();

    int saved = 0;
    try {
      for (final e in planExercises) {
        final sets = _drafts[e.id] ?? const [];
        if (!sets.any((s) => s.done)) continue;

        // Serialize sets as JSON string for Appwrite
        final setsJson = jsonEncode(sets
            .map((s) => SetEntry(reps: s.reps, weight: s.weight, done: s.done).toMap())
            .toList());

        print('Creating log: userId=${user.$id}, planId=${plan.id}, exerciseId=${e.id}, sets=$setsJson');

        await context.read<LogProvider>().createLog(
              userId: user.$id,
              planId: plan.id,
              exerciseId: e.id,
              exerciseName: e.name,
              muscleGroup: e.muscle,
              date: dateStr,
              sets: setsJson,
              notes: notes,
            );
        saved++;
      }

      if (!mounted) return;
      if (saved == 0) {
        showToast(context, 'Mark at least one set as done', isError: true);
        return;
      }
      setState(() => step = 'done');
    } catch (e) {
      if (!mounted) return;
      showToast(context, e.toString(), isError: true);
    }
  }

  void _reset() {
    for (final sets in _drafts.values) {
      for (final s in sets) {
        s.dispose();
      }
    }
    _drafts.clear();
    _notesCtrl.clear();
    setState(() {
      step = 'select';
      selectedPlan = null;
      activeExerciseIndex = 0;
      selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (step == 'done') {
      return _DoneStep(onLogAnother: _reset);
    }
    if (step == 'log') {
      return _LogStep(
        selectedDate: selectedDate,
        plan: selectedPlan!,
        activeExerciseIndex: activeExerciseIndex,
        onBack: () => setState(() => step = 'select'),
        onSelectExercise: (i) => setState(() => activeExerciseIndex = i),
        notesCtrl: _notesCtrl,
        drafts: _drafts,
        exerciseHasDoneSet: _exerciseHasDoneSet,
        onAddSet: (exerciseId) => setState(
          () => _drafts[exerciseId]?.add(_SetDraft(reps: '10', weight: '')),
        ),
        onToggleDone: (exerciseId, idx) =>
            setState(() => _drafts[exerciseId]![idx].toggleDone()),
        onFinish: _finishAndSave,
      );
    }
    return _SelectStep(
      selectedDate: selectedDate,
      onPickDate: _pickDate,
      onSelectPlan: (plan) {
        final exP = context.read<ExerciseProvider>();
        // Collect all unique exercises from all workout days
        final exerciseIds = plan.exerciseIds;
        final planExercises = exerciseIds
            .map((id) => exP.exercises.where((e) => e.id == id).cast<ExerciseModel?>().firstOrNull)
            .whereType<ExerciseModel>()
            .toList();
        _initDrafts(planExercises);
        setState(() {
          selectedPlan = plan;
          activeExerciseIndex = 0;
          step = 'log';
        });
      },
    );
  }
}

class _SelectStep extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPickDate;
  final ValueChanged<PlanModel> onSelectPlan;

  const _SelectStep({
    required this.selectedDate,
    required this.onPickDate,
    required this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    final plansP = context.watch<PlanProvider>();
    final plans = plansP.plans;
    final dateLabel = DateFormat('yyyy-MM-dd').format(selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LOG WORKOUT', style: AppTextStyles.screenTitle.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.lime,
          )),
          const SizedBox(height: 6),
          Text('Select a date and a plan to start logging.',
            style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderLight.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricBlue.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateLabel, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.electricBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.electricBlue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (plansP.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2),
              ),
            )
          else if (plans.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Icon(Icons.fitness_center_outlined, size: 48, color: AppColors.textDim),
                  const SizedBox(height: 12),
                  Text('No plans yet', style: AppTextStyles.exerciseName.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text('Create a plan in Plans tab', style: AppTextStyles.micro.copyWith(color: AppColors.textMuted)),
                ],
              ),
            )
          else
            ...plans.map((plan) => GestureDetector(
                  onTap: () => onSelectPlan(plan),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lime.withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan.name, style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('${plan.totalExercises} exercises', style: AppTextStyles.micro.copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        MuscleChip(muscle: plan.muscleGroup),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}

class _LogStep extends StatelessWidget {
  final DateTime selectedDate;
  final PlanModel plan;
  final int activeExerciseIndex;
  final VoidCallback onBack;
  final ValueChanged<int> onSelectExercise;
  final TextEditingController notesCtrl;
  final Map<String, List<_SetDraft>> drafts;
  final bool Function(String exerciseId) exerciseHasDoneSet;
  final void Function(String exerciseId) onAddSet;
  final void Function(String exerciseId, int idx) onToggleDone;
  final VoidCallback onFinish;

  const _LogStep({
    required this.selectedDate,
    required this.plan,
    required this.activeExerciseIndex,
    required this.onBack,
    required this.onSelectExercise,
    required this.notesCtrl,
    required this.drafts,
    required this.exerciseHasDoneSet,
    required this.onAddSet,
    required this.onToggleDone,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final exP = context.watch<ExerciseProvider>();
    final exercises = plan.exerciseIds
        .map((id) => exP.exercises.where((e) => e.id == id).cast<ExerciseModel?>().firstOrNull)
        .whereType<ExerciseModel>()
        .toList();
    if (exercises.isEmpty) {
      return Center(child: Text('Plan has no exercises.', style: AppTextStyles.secondary));
    }

    final active = exercises[activeExerciseIndex.clamp(0, exercises.length - 1)];
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final sets = drafts[active.id] ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderLight.withOpacity(0.3)),
                ),
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.lime),
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: AppTextStyles.screenTitle.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.lime),
                    ),
                    const SizedBox(height: 2),
                    Text(dateStr, style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: exercises.length,
              itemBuilder: (context, i) {
                final e = exercises[i];
                final isActive = i == activeExerciseIndex;
                final isDone = exerciseHasDoneSet(e.id);
                final bg = isActive ? AppColors.lime : AppColors.cardBg;
                final fg = isActive ? AppColors.appBg : (isDone ? AppColors.lime : AppColors.textMuted);

                return GestureDetector(
                  onTap: () => onSelectExercise(i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.lime : (isDone ? AppColors.electricBlue : AppColors.borderDefault),
                        width: isActive ? 0 : 1,
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: AppColors.lime.withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isDone && !isActive) ...[
                          const Icon(Icons.check_circle, size: 14, color: AppColors.lime),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          e.name,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: fg,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricBlue.withOpacity(0.06),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.muscleBg(active.muscle), AppColors.muscleBg(active.muscle).withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.muscleText(active.muscle).withOpacity(0.3)),
                      ),
                      child: Center(child: Icon(active.icon, size: 20, color: AppColors.textPrimary)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(active.name, style: AppTextStyles.cardTitle.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(active.muscle, style: AppTextStyles.micro.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SetTableHeader(),
                const SizedBox(height: 8),
                ...List.generate(sets.length, (i) {
                  final s = sets[i];
                  return _SetRow(
                    index: i,
                    draft: s,
                    onToggleDone: () => onToggleDone(active.id, i),
                  );
                }),
                GestureDetector(
                  onTap: () => onAddSet(active.id),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      border: Border.all(color: AppColors.borderDefault, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text('+ Add set', style: AppTextStyles.secondary.copyWith(color: AppColors.textMuted, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Notes for this workout...',
                    hintStyle: GoogleFonts.dmSans(color: AppColors.textDim, fontSize: 13),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.borderDefault, width: 0.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onFinish,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18, color: AppColors.appBg),
                        const SizedBox(width: 8),
                        Text('Finish & Save Workout', style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 32, child: Center(child: Text('Set', style: TextStyle(fontSize: 11, color: AppColors.textDim)))),
        const SizedBox(width: 8),
        Expanded(
          child: Center(child: Text('Reps', style: AppTextStyles.micro.copyWith(fontSize: 11))),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Center(child: Text('Weight (kg)', style: AppTextStyles.micro.copyWith(fontSize: 11))),
        ),
        const SizedBox(width: 80),
      ],
    );
  }
}

class _SetRow extends StatelessWidget {
  final int index;
  final _SetDraft draft;
  final VoidCallback onToggleDone;

  const _SetRow({
    required this.index,
    required this.draft,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    final done = draft.done;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: done ? AppColors.lime : AppColors.inputBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: done
                      ? const Text('✓', style: TextStyle(color: AppColors.appBg, fontWeight: FontWeight.w700))
                      : Text('${index + 1}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: draft.repsCtrl,
              enabled: !done,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: draft.weightCtrl,
              enabled: !done,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'kg'),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: done
                ? Text('Logged', style: AppTextStyles.micro.copyWith(color: AppColors.lime), textAlign: TextAlign.center)
                : SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onToggleDone,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Done',
                        style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  final VoidCallback onLogAnother;
  const _DoneStep({required this.onLogAnother});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('WORKOUT COMPLETE!', style: AppTextStyles.completionTitle),
          const SizedBox(height: 8),
          Text('Your session has been saved.', style: AppTextStyles.secondary),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onLogAnother,
            child: const Text('Log Another'),
          ),
        ],
      ),
    );
  }
}

class _SetDraft {
  final TextEditingController repsCtrl;
  final TextEditingController weightCtrl;
  bool done = false;

  _SetDraft({required String reps, required String weight})
      : repsCtrl = TextEditingController(text: reps),
        weightCtrl = TextEditingController(text: weight);

  String get reps => repsCtrl.text.trim();
  String get weight => weightCtrl.text.trim();

  void toggleDone() {
    done = true;
  }

  void dispose() {
    repsCtrl.dispose();
    weightCtrl.dispose();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

