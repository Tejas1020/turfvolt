import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
import '../../../widgets/glass_card.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/lime_button.dart';
import '../../../widgets/mesh_gradient_background.dart';
import '../../../widgets/fitness_illustrations.dart';
import '../../../widgets/shimmer.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String step = 'select';
  DateTime selectedDate = DateTime.now();
  PlanModel? selectedPlan;
  int activeExerciseIndex = 0;
  final _notesCtrl = TextEditingController();
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
      _drafts[e.id] = List.generate(3, (_) => _SetDraft(reps: '10', weight: ''));
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
                  primary: AppColors.vibrantCoral,
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

        final setsJson = jsonEncode(sets
            .map((s) => SetEntry(reps: s.reps, weight: s.weight, done: s.done).toMap())
            .toList());

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
      return MeshGradientBackground(
        child: SafeArea(
          child: _LogStep(
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
          ),
        ),
      );
    }
    return MeshGradientBackground(
      child: SafeArea(
        child: _SelectStep(
          selectedDate: selectedDate,
          onPickDate: _pickDate,
          onSelectPlan: (plan) {
            final exP = context.read<ExerciseProvider>();
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
        ),
      ),
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
          GradientText.coralOrange(
            'LOG WORKOUT',
            style: AppTextStyles.gradientHero.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(
            'Select a date and plan to start tracking',
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          // Date Picker
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calendar_today_rounded, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        dateLabel,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_drop_down_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (plansP.loading)
            Shimmer(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ShimmerListItem(height: 90),
                ),
              ),
            )
          else if (plans.isEmpty)
            GlassCard(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.fitness_center_outlined, size: 48, color: AppColors.textDim),
                  const SizedBox(height: 12),
                  Text(
                    'No plans yet',
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create a plan in Plans tab',
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          else
            ...plans.map((plan) => GestureDetector(
                  onTap: () => onSelectPlan(plan),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
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
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${plan.totalExercises} exercises',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.glassFill,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.arrow_forward_rounded, color: AppColors.vibrantCoral, size: 18),
                        ),
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
      return Center(
        child: Text(
          'Plan has no exercises',
          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
        ),
      );
    }

    final active = exercises[activeExerciseIndex.clamp(0, exercises.length - 1)];
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final sets = drafts[active.id] ?? const [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.vibrantCoral, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText.coralOrange(
                      plan.name,
                      style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 0.5),
                    ),
                    Text(dateStr, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Exercise Carousel with Illustration
          SizedBox(
            height: 160,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    onPageChanged: (i) => onSelectExercise(i),
                    itemCount: exercises.length,
                    itemBuilder: (context, i) {
                      final e = exercises[i];
                      final isActive = i == activeExerciseIndex;
                      return AnimatedScale(
                        scale: isActive ? 1.0 : 0.85,
                        duration: const Duration(milliseconds: 300),
                        child: AnimatedOpacity(
                          opacity: isActive ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 300),
                          child: _ExerciseIllustrationCard(
                            exercise: e,
                            isActive: isActive,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(exercises.length, (i) {
                    final isActive = i == activeExerciseIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.vibrantCoral : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: isActive
                            ? [BoxShadow(color: AppColors.vibrantCoral.withAlpha(77), blurRadius: 8)]
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Exercise Details Card
          GlassCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        active.icon ?? Icons.fitness_center_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            active.name,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.muscleBg(active.muscle),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              active.muscle,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.muscleText(active.muscle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Set Headers
                Row(
                  children: [
                    const SizedBox(width: 36, child: Center(child: Text('Set', style: TextStyle(fontSize: 11, color: AppColors.textDim)))),
                    const SizedBox(width: 8),
                    Expanded(child: Center(child: Text('Reps', style: TextStyle(fontSize: 11, color: AppColors.textDim)))),
                    const SizedBox(width: 8),
                    Expanded(child: Center(child: Text('Weight', style: TextStyle(fontSize: 11, color: AppColors.textDim)))),
                    const SizedBox(width: 80),
                  ],
                ),
                const SizedBox(height: 8),
                // Set Rows
                ...List.generate(sets.length, (i) {
                  final s = sets[i];
                  return _SetRow(
                    index: i,
                    draft: s,
                    onToggleDone: () => onToggleDone(active.id, i),
                  );
                }),
                // Add Set Button
                GestureDetector(
                  onTap: () => onAddSet(active.id),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text(
                          '+ Add set',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Notes
                TextField(
                  controller: notesCtrl,
                  maxLines: 3,
                  style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Notes for this workout...',
                    hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textDim),
                    filled: true,
                    fillColor: AppColors.inputBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // Finish Button
                SizedBox(
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.vibrantCoral.withAlpha(102),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFinish,
                        borderRadius: BorderRadius.circular(14),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 20, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Finish & Save Workout',
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

class _ExerciseIllustrationCard extends StatelessWidget {
  final ExerciseModel exercise;
  final bool isActive;

  const _ExerciseIllustrationCard({
    required this.exercise,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardBg,
            AppColors.muscleBg(exercise.muscle).withAlpha(26),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.vibrantCoral.withAlpha(77) : AppColors.border,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.vibrantCoral.withAlpha(51),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            child: Center(
              child: _getMuscleIllustration(exercise.muscle),
            ),
          ),
          const SizedBox(height: 8),
          // Exercise name
          Text(
            exercise.name,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Muscle group chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.muscleBg(exercise.muscle),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              exercise.muscle,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.muscleText(exercise.muscle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMuscleIllustration(String muscle) {
    // Return appropriate illustration based on muscle group
    switch (muscle.toLowerCase()) {
      case 'chest':
      case 'upper chest':
      case 'lower chest':
        return const LiftingIllustration(size: 80);
      case 'back':
        return const RunningIllustration(size: 80);
      case 'shoulders':
        return const DumbbellIllustration(size: 80);
      case 'biceps':
      case 'triceps':
      case 'forearms':
        return const FitnessIllustration(type: FitnessIllustrationType.muscle, size: 80);
      case 'quads':
      case 'hamstrings':
      case 'glutes':
      case 'calves':
        return const LiftingIllustration(size: 80);
      case 'core':
        return const FlameIllustration(size: 80);
      default:
        return const HeartIllustration(size: 80);
    }
  }
}

class _MuscleIllustration extends StatelessWidget {
  final double size;

  const _MuscleIllustration({this.size = 200});

  @override
  Widget build(BuildContext context) {
    return FitnessIllustration(
      type: FitnessIllustrationType.muscle,
      size: size,
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
            width: 36,
            child: Center(
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: done ? AppColors.success : AppColors.inputBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
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
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: done ? AppColors.inputBg : AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: draft.weightCtrl,
              enabled: !done,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                filled: true,
                fillColor: done ? AppColors.inputBg : AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'kg',
                hintStyle: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textDim),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: done
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Done',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onToggleDone,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Done',
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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

class _DoneStep extends StatelessWidget {
  final VoidCallback onLogAnother;

  const _DoneStep({required this.onLogAnother});

  @override
  Widget build(BuildContext context) {
    return MeshGradientBackground(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.vibrantCoral.withAlpha(102),
                        blurRadius: 40,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 64),
                ),
                const SizedBox(height: 32),
                GradientText.coralOrange(
                  'WORKOUT COMPLETE!',
                  style: AppTextStyles.gradientHero.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your session has been saved.\nKeep up the great work!',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  child: LimeButton(
                    label: 'Log Another',
                    onPressed: onLogAnother,
                    icon: Icons.add_rounded,
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ),
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
