import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/plan_model.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/fitness_illustrations.dart';
import '../../../widgets/shimmer.dart';

/// Plan creation screen
/// Users can create a plan with exercises
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
  String _searchQuery = '';
  List<ExerciseModel>? _exercisesCache;

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
        if (plan.workoutDays.isNotEmpty) {
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

  void _toggleExercise(ExerciseModel ex) {
    if (!mounted) return;
    _dayExercises.putIfAbsent(_selectedDay, () => []);
    final list = _dayExercises[_selectedDay]!;
    final existing = list.indexWhere((e) => e.exerciseId == ex.id);
    setState(() {
      if (existing >= 0) {
        list.removeAt(existing);
      } else {
        list.add(DayExercise(
          exerciseId: ex.id,
          exerciseName: ex.name,
          muscleGroup: ex.muscle,
          sets: 3,
          reps: 10,
        ));
      }
    });
  }

  bool _isSelected(ExerciseModel ex) {
    final list = _dayExercises[_selectedDay];
    return list != null && list.any((e) => e.exerciseId == ex.id);
  }

  static const _muscleOrder = [
    'Upper Chest', 'Lower Chest', 'Chest',
    'Back', 'Shoulders',
    'Biceps', 'Triceps', 'Forearms',
    'Quads', 'Hamstrings', 'Glutes', 'Calves',
    'Core', 'Full Body',
  ];

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
        await planProvider.createPlanWithDays(
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
        Navigator.pop(context);
      }
      setState(() => _saving = false);
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Failed: ${e.toString()}', isError: true);
      setState(() => _saving = false);
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Plan',
          style: AppTextStyles.headline.copyWith(fontSize: 18),
        ),
        actions: [
          if (!_saving)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: _savePlan,
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
      body: _buildPlanCreationView(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected exercises horizontal carousel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Selected Exercises',
            style: AppTextStyles.bodySecondary.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: _buildSelectedExercisesCarousel(),
        ),
        const SizedBox(height: 12),
        // Browse by muscle group
        Expanded(
          child: _buildGroupedExercisesList(),
        ),
      ],
    );
  }

  Widget _buildGroupedExercisesList() {
    final groupedExercises = _groupedExercises;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _sortedMuscleGroups.length,
      itemBuilder: (_, i) {
        final muscle = _sortedMuscleGroups[i];
        final exercises = groupedExercises[muscle] ?? [];
        return _MuscleGroupCarousel(
          muscle: muscle,
          exercises: exercises,
          isSelected: _isSelected,
          onToggleExercise: _toggleExercise,
        );
      },
    );
  }

  Widget _buildSelectedExercisesCarousel() {
    final selectedExercises = _dayExercises[_selectedDay] ?? [];

    if (selectedExercises.isEmpty) {
      return Center(
        child: Text(
          'Tap exercises below to add',
          style: AppTextStyles.bodySecondary.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: selectedExercises.length,
      itemBuilder: (_, i) {
        final exercise = selectedExercises[i];
        // Look up full exercise model from cache
        final fullExercise = _exercisesCache?.firstWhere(
          (e) => e.id == exercise.exerciseId,
          orElse: () => ExerciseModel(
            id: exercise.exerciseId,
            name: exercise.exerciseName,
            muscle: exercise.muscleGroup,
            desc: 'Focus on controlled movement and proper form.',
            icon: Icons.fitness_center,
          ),
        );
        return SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ExerciseCarouselCard(
              exerciseName: exercise.exerciseName,
              muscleGroup: exercise.muscleGroup,
              isSelected: true,
              onTap: () => _toggleExercise(ExerciseModel(
                id: exercise.exerciseId,
                name: exercise.exerciseName,
                muscle: exercise.muscleGroup,
                desc: fullExercise?.desc ?? '',
                icon: Icons.fitness_center,
              )),
              exercise: fullExercise,
            ),
          ),
        );
      },
    );
  }
}

class _ExerciseCarouselCard extends StatelessWidget {
  final String exerciseName;
  final String muscleGroup;
  final bool isSelected;
  final VoidCallback onTap;
  final ExerciseModel? exercise;

  const _ExerciseCarouselCard({
    required this.exerciseName,
    required this.muscleGroup,
    required this.isSelected,
    required this.onTap,
    this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.muscleText(muscleGroup);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise GIF illustration or icon fallback
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Professional exercise GIF animation
                    ExerciseIllustration(
                      exerciseName: exerciseName,
                      size: 60,
                      loop: true,
                    ),
                    // Info button - show exercise details
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (exercise != null) {
                            showExerciseDetails(context, {
                              'name': exerciseName,
                              'muscle': muscleGroup,
                              'desc': exercise?.desc ?? 'Focus on controlled movement and proper form.',
                              'icon': '',
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: color,
                            size: 10,
                          ),
                        ),
                      ),
                    ),
                    // Selected checkmark
                    if (isSelected)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Exercise name
              const SizedBox(height: 4),
              Text(
                exerciseName,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? color : AppColors.textPrimary,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                muscleGroup,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MuscleGroupCarousel extends StatelessWidget {
  final String muscle;
  final List<ExerciseModel> exercises;
  final bool Function(ExerciseModel) isSelected;
  final void Function(ExerciseModel) onToggleExercise;

  const _MuscleGroupCarousel({
    required this.muscle,
    required this.exercises,
    required this.isSelected,
    required this.onToggleExercise,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.muscleText(muscle);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Muscle group header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                muscle,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${exercises.length}',
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Horizontal carousel of exercises
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: exercises.length,
              itemBuilder: (_, i) {
                final exercise = exercises[i];
                final selected = isSelected(exercise);
                return SizedBox(
                  width: 110,
                  child: Padding(
                    padding: EdgeInsets.only(right: i < exercises.length - 1 ? 12 : 0),
                    child: _ExerciseCarouselCard(
                      exerciseName: exercise.name,
                      muscleGroup: exercise.muscle,
                      isSelected: selected,
                      onTap: () => onToggleExercise(exercise),
                      exercise: exercise,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
