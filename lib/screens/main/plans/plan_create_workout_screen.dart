import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/plan_model.dart';
import '../../../models/exercise_model.dart';
import '../../../models/set_entry_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../providers/log_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/lime_button.dart';

/// Combined plan creation + workout tracking screen
/// Users can create a plan with exercises and immediately start the workout
class PlanCreateWorkoutScreen extends StatefulWidget {
  final String? planId; // If provided, edit existing plan

  const PlanCreateWorkoutScreen({
    super.key,
    this.planId,
  });

  @override
  State<PlanCreateWorkoutScreen> createState() => _PlanCreateWorkoutScreenState();
}

class _PlanCreateWorkoutScreenState extends State<PlanCreateWorkoutScreen> {
  final _nameCtrl = TextEditingController();
  Weekday _selectedDay = Weekday.monday;
  final _dayExercises = <Weekday, List<DayExercise>>{};
  bool _saving = false;
  bool _workoutStarted = false;
  String _searchQuery = '';
  String? _expandedMuscleGroup;
  List<ExerciseModel>? _exercisesCache;
  String? _createdPlanId; // Store newly created plan ID

  // Workout tracking state
  final _exerciseSets = <String, List<SetEntry>>{};
  final _exerciseNotes = <String, String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ExerciseProvider>();
      setState(() {
        _exercisesCache = provider.exercises;
      });
    });

    // Load existing plan if editing
    if (widget.planId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final plan = context.read<PlanProvider>().getPlanById(widget.planId!);
        if (plan != null) {
          _nameCtrl.text = plan.name;
          // Load ALL days and their exercises from the plan
          for (final day in plan.workoutDays) {
            _dayExercises[day.weekday] = day.exercises;
          }
          // Default to first day's weekday
          _selectedDay = plan.workoutDays.first.weekday;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _selectDay(Weekday day) {
    setState(() {
      _selectedDay = day;
      _dayExercises.putIfAbsent(day, () => []);
    });
  }

  void _repeatWorkoutToAnotherDay() {
    final currentExercises = _dayExercises[_selectedDay];
    if (currentExercises == null || currentExercises.isEmpty) {
      showToast(context, 'Add exercises first to repeat', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(
          'Repeat on Day',
          style: AppTextStyles.headline.copyWith(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Copy "${_dayExercises[_selectedDay]!.length} exercises" to another day',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 16),
            ...Weekday.values.map((day) {
              final alreadyHasExercises = (_dayExercises[day] ?? []).isNotEmpty;
              final isCurrentDay = day == _selectedDay;
              return ListTile(
                leading: Icon(
                  day.icon,
                  color: isCurrentDay
                      ? AppColors.textMuted
                      : alreadyHasExercises
                          ? AppColors.summerOrange
                          : AppColors.success,
                ),
                title: Text(
                  day.displayName,
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: isCurrentDay ? AppColors.textMuted : null,
                  ),
                ),
                subtitle: Text(
                  isCurrentDay
                      ? 'Current day'
                      : alreadyHasExercises
                          ? '${_dayExercises[day]!.length} exercises (will replace)'
                          : 'Empty',
                  style: AppTextStyles.micro,
                ),
                enabled: !isCurrentDay,
                onTap: () {
                  Navigator.pop(ctx);
                  _copyExercisesToDay(day);
                },
                trailing: isCurrentDay
                    ? null
                    : alreadyHasExercises
                        ? const Icon(Icons.warning_amber_rounded,
                            color: AppColors.summerOrange, size: 20)
                        : const Icon(Icons.add_circle_outline,
                            color: AppColors.success, size: 20),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonPrimary.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyExercisesToDay(Weekday targetDay) {
    final sourceExercises = _dayExercises[_selectedDay];
    if (sourceExercises == null) return;

    setState(() {
      // Deep copy exercises to target day (independent copies)
      _dayExercises[targetDay] = sourceExercises.map((e) {
        return DayExercise(
          exerciseId: e.exerciseId,
          exerciseName: e.exerciseName,
          muscleGroup: e.muscleGroup,
          sets: e.sets,
          reps: e.reps,
        );
      }).toList();

      // Also copy the set entries for workout tracking
      for (final ex in sourceExercises) {
        if (_exerciseSets.containsKey(ex.exerciseId)) {
          _exerciseSets['${ex.exerciseId}_${targetDay.name}'] =
              _exerciseSets[ex.exerciseId]!.map((s) {
            return SetEntry(
              weight: s.weight,
              reps: s.reps,
              done: false,
            );
          }).toList();
        }
      }
    });

    showToast(context, 'Repeated on ${targetDay.displayName}');
  }

  void _toggleExercise(ExerciseModel ex) {
    setState(() {
      final list = _dayExercises[_selectedDay]!;
      final existing = list.indexWhere((e) => e.exerciseId == ex.id);
      if (existing >= 0) {
        list.removeAt(existing);
        _exerciseSets.remove(ex.id);
      } else {
        list.add(DayExercise(
          exerciseId: ex.id,
          exerciseName: ex.name,
          muscleGroup: ex.muscle,
          sets: 3,
          reps: 10,
        ));
        _exerciseSets[ex.id] = List.generate(
          3,
          (i) => SetEntry(reps: '10', weight: '0', done: false),
        );
      }
    });
  }

  bool _isSelected(ExerciseModel ex) {
    return _dayExercises[_selectedDay]!.any((e) => e.exerciseId == ex.id);
  }

  Map<String, List<ExerciseModel>> get _groupedExercises {
    final all = _exercisesCache ?? [];
    List<ExerciseModel> filtered = all;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = all.where((e) =>
        e.name.toLowerCase().contains(q) ||
        e.muscle.toLowerCase().contains(q)
      ).toList();
    }
    final groups = <String, List<ExerciseModel>>{};
    for (final ex in filtered) {
      groups.putIfAbsent(ex.muscle, () => []);
      groups[ex.muscle]!.add(ex);
    }
    for (final key in groups.keys) {
      groups[key]!.sort((a, b) => a.name.compareTo(b.name));
    }
    return groups;
  }

  static const _muscleOrder = [
    'Upper Chest', 'Lower Chest', 'Chest',
    'Back', 'Shoulders',
    'Biceps', 'Triceps', 'Forearms',
    'Quads', 'Hamstrings', 'Glutes', 'Calves',
    'Core', 'Full Body',
  ];

  List<String> get _sortedMuscleGroups {
    final groups = _groupedExercises.keys.toList();
    groups.sort((a, b) {
      final aIndex = _muscleOrder.indexOf(a);
      final bIndex = _muscleOrder.indexOf(b);
      if (aIndex == -1 && bIndex == -1) return a.compareTo(b);
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });
    return groups;
  }

  Future<void> _savePlan() async {
    if (_nameCtrl.text.trim().isEmpty) {
      showToast(context, 'Enter plan name', isError: true);
      return;
    }
    final exercises = _dayExercises[_selectedDay] ?? [];
    if (exercises.isEmpty) {
      showToast(context, 'Add at least one exercise', isError: true);
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) {
      showToast(context, 'Login required', isError: true);
      return;
    }

    setState(() => _saving = true);

    try {
      final planProvider = context.read<PlanProvider>();

      if (widget.planId != null) {
        // Update existing plan — update name AND the selected day's exercises
        await planProvider.updatePlan(
          widget.planId!,
          name: _nameCtrl.text.trim(),
        );

        // Sync the selected day's exercises to Appwrite
        await planProvider.updateWorkoutDay(
          planId: widget.planId!,
          weekday: _selectedDay,
          name: '${_selectedDay.displayName} Workout',
          exercises: exercises,
        );

        if (!mounted) return;
        showToast(context, 'Plan updated!');
      } else {
        // Create new plan
        final plan = await planProvider.createPlanWithDays(
          userId: user.$id,
          name: _nameCtrl.text.trim(),
          days: [
            WorkoutDay(
              weekday: _selectedDay,
              name: '${_selectedDay.displayName} Workout',
              exercises: exercises,
            ),
          ],
        );
        if (!mounted) return;
        showToast(context, 'Plan created!');
        // Store the new plan ID for starting workout
        _createdPlanId = plan.id;
      }
      setState(() => _saving = false);
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Failed: ${e.toString()}', isError: true);
      setState(() => _saving = false);
    }
  }

  String? get _activePlanId => widget.planId ?? _createdPlanId;

  void _startWorkout() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) {
      showToast(context, 'Login required', isError: true);
      return;
    }

    if (_activePlanId == null) {
      // Save plan first
      await _savePlan();
      if (_activePlanId == null) return;
    }

    setState(() => _workoutStarted = true);
  }

  void _completeWorkout() async {
    final user = context.read<AuthProvider>().user;
    if (user == null || _activePlanId == null) return;

    final exercises = _dayExercises[_selectedDay] ?? [];
    if (exercises.isEmpty) return;

    setState(() => _saving = true);

    try {
      for (final dayExercise in exercises) {
        final sets = _exerciseSets[dayExercise.exerciseId] ?? [];
        if (sets.isEmpty) continue;

        await context.read<LogProvider>().createLog(
          userId: user.$id,
          planId: _activePlanId!,
          exerciseId: dayExercise.exerciseId,
          exerciseName: dayExercise.exerciseName,
          muscleGroup: dayExercise.muscleGroup,
          date: DateTime.now().toIso8601String(),
          sets: sets,
          notes: _exerciseNotes[dayExercise.exerciseId] ?? '',
        );
      }

      if (!mounted) return;
      showToast(context, 'Workout completed! Great job!');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Failed to save: ${e.toString()}', isError: true);
    }
    setState(() => _saving = false);
  }

  void _updateSet(String exerciseId, int setIndex, String field, dynamic value) {
    setState(() {
      final sets = _exerciseSets[exerciseId];
      if (sets == null || setIndex >= sets.length) return;
      final set = sets[setIndex];
      if (field == 'weight') {
        sets[setIndex] = SetEntry(
          weight: value.toString(),
          reps: set.reps,
          done: set.done,
        );
      } else if (field == 'reps') {
        sets[setIndex] = SetEntry(
          weight: set.weight,
          reps: value.toString(),
          done: set.done,
        );
      } else if (field == 'done') {
        sets[setIndex] = SetEntry(
          weight: set.weight,
          reps: set.reps,
          done: value as bool,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: _workoutStarted ? null : () => Navigator.pop(context),
        ),
        title: Text(
          _workoutStarted ? 'Workout' : 'Create Plan',
          style: AppTextStyles.headline.copyWith(fontSize: 18),
        ),
        actions: [
          if (!_workoutStarted && !_saving)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: _workoutStarted ? null : _savePlan,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.summerOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Save',
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _workoutStarted
          ? _buildWorkoutView()
          : _buildPlanCreationView(),
    );
  }

  Widget _buildPlanCreationView() {
    return Column(
      children: [
        _buildNameField(),
        _buildDaySelector(),
        Expanded(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _buildExerciseList(),
              ),
            ],
          ),
        ),
        _buildStartWorkoutButton(),
      ],
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _nameCtrl,
        autofocus: true,
        style: AppTextStyles.bodyPrimary.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: 'Plan Name',
          hintText: 'e.g., Chest & Triceps Day',
          labelStyle: AppTextStyles.inputHint,
          hintStyle: AppTextStyles.inputHint,
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.summerOrange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fitness_center_rounded, color: AppColors.summerOrange, size: 22),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: Weekday.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final day = Weekday.values[i];
          final selected = _selectedDay == day;
          return GestureDetector(
            onTap: () => _selectDay(day),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: [AppColors.summerOrange, AppColors.sunshineYellow],
                      )
                    : null,
                color: selected ? null : AppColors.cardBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? AppColors.summerOrange : AppColors.borderLight,
                  width: selected ? 0 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    day.icon,
                    size: 18,
                    color: selected ? Colors.white : AppColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    day.displayName,
                    style: AppTextStyles.bodySecondary.copyWith(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: AppTextStyles.bodyPrimary,
        decoration: InputDecoration(
          hintText: 'Search exercises...',
          labelStyle: AppTextStyles.inputHint,
          hintStyle: AppTextStyles.inputHint,
          filled: true,
          fillColor: AppColors.inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    final exercises = _groupedExercises;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sortedMuscleGroups.length,
      itemBuilder: (_, i) {
        final muscle = _sortedMuscleGroups[i];
        final muscleExercises = exercises[muscle] ?? [];
        final expanded = _expandedMuscleGroup == muscle;
        return _MuscleGroupSection(
          muscle: muscle,
          exercises: muscleExercises,
          expanded: expanded,
          onToggle: () => setState(() {
            _expandedMuscleGroup = expanded ? null : muscle;
          }),
          isSelected: _isSelected,
          onToggleExercise: _toggleExercise,
        );
      },
    );
  }

  Widget _buildStartWorkoutButton() {
    final exercises = _dayExercises[_selectedDay] ?? [];
    final hasExercises = exercises.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (hasExercises) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _saving ? null : _repeatWorkoutToAnotherDay,
                icon: const Icon(Icons.copy_rounded, size: 20),
                label: Text(
                  'Repeat Workout on Another Day',
                  style: AppTextStyles.buttonPrimary.copyWith(
                    color: AppColors.summerOrange,
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.summerOrange, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          LimeButton(
            label: hasExercises ? 'Start Workout' : 'Add exercises to start',
            onPressed: hasExercises && !_saving ? _startWorkout : null,
            icon: Icons.play_arrow_rounded,
            fullWidth: true,
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutView() {
    final exercises = _dayExercises[_selectedDay] ?? [];
    if (exercises.isEmpty) {
      return const Center(child: Text('No exercises'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            itemBuilder: (_, i) {
              final exercise = exercises[i];
              final sets = _exerciseSets[exercise.exerciseId] ?? [];
              return _ExerciseWorkoutCard(
                exercise: exercise,
                sets: sets,
                notes: _exerciseNotes[exercise.exerciseId] ?? '',
                onSetUpdate: _updateSet,
                onNotesChange: (v) => setState(() {
                  _exerciseNotes[exercise.exerciseId] = v;
                }),
              );
            },
          ),
        ),
        _buildCompleteWorkoutButton(),
      ],
    );
  }

  Widget _buildCompleteWorkoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LimeButton(
        label: 'Complete Workout',
        onPressed: _saving ? null : _completeWorkout,
        icon: Icons.check,
        fullWidth: true,
        size: ButtonSize.large,
      ),
    );
  }
}

class _MuscleGroupSection extends StatelessWidget {
  final String muscle;
  final List<ExerciseModel> exercises;
  final bool expanded;
  final VoidCallback onToggle;
  final bool Function(ExerciseModel) isSelected;
  final void Function(ExerciseModel) onToggleExercise;

  const _MuscleGroupSection({
    required this.muscle,
    required this.exercises,
    required this.expanded,
    required this.onToggle,
    required this.isSelected,
    required this.onToggleExercise,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.muscleText(muscle);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.fitness_center, color: color, size: 18),
            ),
            title: Text(
              muscle,
              style: AppTextStyles.cardTitle,
            ),
            subtitle: Text(
              '${exercises.length} exercises',
              style: AppTextStyles.micro,
            ),
            trailing: Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.textMuted,
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            ...exercises.map((ex) => _ExerciseTile(
              exercise: ex,
              selected: isSelected(ex),
              onTap: () => onToggleExercise(ex),
            )),
          ],
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final ExerciseModel exercise;
  final bool selected;
  final VoidCallback onTap;

  const _ExerciseTile({
    required this.exercise,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.muscleText(exercise.muscle);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        selected ? Icons.check_circle : Icons.add_circle_outline,
        color: selected ? color : AppColors.textMuted,
        size: 24,
      ),
      title: Text(
        exercise.name,
        style: AppTextStyles.bodySecondary.copyWith(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? color : AppColors.textMuted,
        ),
      ),
      subtitle: Text(
        exercise.muscle,
        style: AppTextStyles.micro,
      ),
      trailing: selected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '3 x 10',
                style: AppTextStyles.micro.copyWith(color: color),
              ),
            )
          : null,
    );
  }
}

class _ExerciseWorkoutCard extends StatelessWidget {
  final DayExercise exercise;
  final List<SetEntry> sets;
  final String notes;
  final void Function(String, int, String, dynamic) onSetUpdate;
  final void Function(String) onNotesChange;

  const _ExerciseWorkoutCard({
    required this.exercise,
    required this.sets,
    required this.notes,
    required this.onSetUpdate,
    required this.onNotesChange,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.muscleText(exercise.muscleGroup);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.fitness_center, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.exerciseName,
                      style: AppTextStyles.cardTitle,
                    ),
                    Text(
                      exercise.muscleGroup,
                      style: AppTextStyles.micro,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sets.asMap().entries.map((entry) {
            final i = entry.key;
            final set = entry.value;
            return _SetRow(
              setNumber: i + 1,
              weight: set.weight,
              reps: set.reps,
              done: set.done,
              onWeightChange: (v) => onSetUpdate(exercise.exerciseId, i, 'weight', v),
              onRepsChange: (v) => onSetUpdate(exercise.exerciseId, i, 'reps', v),
              onDoneChange: (v) => onSetUpdate(exercise.exerciseId, i, 'done', v),
            );
          }),
          const SizedBox(height: 12),
          TextField(
            onChanged: onNotesChange,
            maxLines: 2,
            style: AppTextStyles.bodySecondary,
            decoration: InputDecoration(
              hintText: 'Notes (optional)',
              labelStyle: AppTextStyles.inputHint,
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            controller: TextEditingController(text: notes),
          ),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final int setNumber;
  final String weight;
  final String reps;
  final bool done;
  final void Function(double) onWeightChange;
  final void Function(int) onRepsChange;
  final void Function(bool) onDoneChange;

  const _SetRow({
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.done,
    required this.onWeightChange,
    required this.onRepsChange,
    required this.onDoneChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Set $setNumber',
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            style: AppTextStyles.bodyPrimary,
            decoration: InputDecoration(
              hintText: 'Weight',
              labelStyle: AppTextStyles.inputHint,
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) {
              final val = double.tryParse(v);
              if (val != null) onWeightChange(val);
            },
            controller: TextEditingController(text: weight == '0' ? '' : weight),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: TextField(
            keyboardType: TextInputType.number,
            style: AppTextStyles.bodyPrimary,
            decoration: InputDecoration(
              hintText: 'Reps',
              labelStyle: AppTextStyles.inputHint,
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) {
              final val = int.tryParse(v);
              if (val != null) onRepsChange(val);
            },
            controller: TextEditingController(text: reps),
          ),
        ),
        const SizedBox(width: 8),
        Checkbox(
          value: done,
          onChanged: (v) => onDoneChange(v ?? false),
          activeColor: AppColors.success,
        ),
      ],
    );
  }
}
