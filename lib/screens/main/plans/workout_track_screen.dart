import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/app_colors.dart';
import '../../../providers/plan_provider.dart';
import '../../../models/plan_model.dart';

/// Workout tracking screen for logging completed workouts
/// Allows users to track sets, reps, weight, and view workout history
class WorkoutTrackScreen extends StatefulWidget {
  final String planId;
  final Weekday weekday;

  const WorkoutTrackScreen({
    super.key,
    required this.planId,
    required this.weekday,
  });

  @override
  State<WorkoutTrackScreen> createState() => _WorkoutTrackScreenState();
}

class _WorkoutTrackScreenState extends State<WorkoutTrackScreen> {
  DateTime? _lastWorkoutDate;

  @override
  Widget build(BuildContext context) {
    final plansP = context.watch<PlanProvider>();
    final plan = plansP.getPlanById(widget.planId);
    final workoutDay = plan.workoutDays.firstWhere(
      (d) => d.weekday == widget.weekday,
      orElse: () => WorkoutDay(weekday: widget.weekday),
    );

    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(widget.weekday.icon, size: 20, color: AppColors.lime),
            const SizedBox(width: 8),
            Text(
              '${widget.weekday.displayName} Workout',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ],
        ),
        actions: [
          if (workoutDay.exercises.isNotEmpty)
            IconButton(
              icon: Icon(Icons.play_arrow, color: AppColors.lime),
              onPressed: () => _startWorkout(workoutDay),
              tooltip: 'Start workout',
            ),
        ],
      ),
      body: workoutDay.exercises.isEmpty
          ? _buildEmptyState()
          : _buildWorkoutContent(workoutDay),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
                  'No Exercises Yet',
                  style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add exercises to your ${widget.weekday.displayName} workout first',
                  style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add, color: AppColors.appBg),
                  label: Text('Add Exercises', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.appBg)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.appBg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutContent(WorkoutDay day) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Motivational Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lime.withOpacity(0.2), AppColors.lime.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lime.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.weekday.motivationalMessage,
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lime,
                          height: 1.3,
                        ),
                      ),
                      if (day.name.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          day.name,
                          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.weekday.icon,
                    size: 28,
                    color: AppColors.lime,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Workout Stats
          Row(
            children: [
              _buildStatCard(
                '${day.exercises.length}',
                'Exercises',
                Icons.fitness_center,
                AppColors.lime,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                '${day.estimatedDuration} min',
                'Est. Time',
                Icons.timer,
                AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Exercise List
          Text(
            'WORKOUT EXERCISES',
            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          ...day.exercises.map((exercise) => _buildExerciseTile(exercise)),

          // Last Workout Info
          if (_lastWorkoutDate != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: AppColors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Workout',
                          style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatLastWorkoutDate(_lastWorkoutDate!),
                          style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w700, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(DayExercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDefault.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.muscleText(exercise.muscleGroup).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.fitness_center, color: AppColors.muscleText(exercise.muscleGroup), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildChip('${exercise.sets} sets', Icons.format_list_numbered),
                          _buildChip('${exercise.reps} reps', Icons.repeat),
                          if (exercise.weightKg != null && exercise.weightKg! > 0)
                            _buildChip('${exercise.weightKg!.toStringAsFixed(1)} kg', Icons.fitness_center),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Quick Log Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              border: Border(
                top: BorderSide(color: AppColors.borderDefault, width: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOG SETS',
                  style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _logSet(exercise, completed: true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.lime.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.lime.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: AppColors.lime, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Complete',
                                style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lime),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Future<void> _startWorkout(WorkoutDay day) async {
    // Navigate to active workout screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveWorkoutScreen(
          planId: widget.planId,
          weekday: widget.weekday,
          exercises: day.exercises,
        ),
      ),
    );
  }

  Future<void> _logSet(DayExercise exercise, {required bool completed}) async {
    try {
      // Update the exercise with last performed date
      await context.read<PlanProvider>().updateExerciseInDay(
            planId: widget.planId,
            weekday: widget.weekday,
            exerciseId: exercise.exerciseId,
            lastPerformed: completed ? DateTime.now() : exercise.lastPerformed,
          );
      setState(() {
        _lastWorkoutDate = DateTime.now();
      });
      if (completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${exercise.exerciseName} logged!'),
            backgroundColor: AppColors.lime,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.coral,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _formatLastWorkoutDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${date.minute.toString().padLeft(2, '0')} $amPm';
  }
}

/// Active workout screen for real-time workout logging
class ActiveWorkoutScreen extends StatefulWidget {
  final String planId;
  final Weekday weekday;
  final List<DayExercise> exercises;

  const ActiveWorkoutScreen({
    super.key,
    required this.planId,
    required this.weekday,
    required this.exercises,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final Map<String, List<bool>> _completedSets = {};
  DateTime? _startTime;
  bool _workoutComplete = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    for (final exercise in widget.exercises) {
      _completedSets[exercise.exerciseId] = List.filled(exercise.sets, false);
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
          'Active Workout',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          if (_workoutComplete)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lime.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.lime, size: 16),
                  const SizedBox(width: 4),
                  Text('Complete', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lime)),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Timer and Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lime.withOpacity(0.15), AppColors.lime.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.borderDefault, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.weekday.displayName,
                        style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(DateTime.now().difference(_startTime ?? DateTime.now())),
                        style: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.lime, fontFeatures: const [FontFeature.tabularFigures()]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildMiniStat('${_getTotalCompletedSets()}/${widget.exercises.fold<int>(0, (sum, e) => sum + e.sets)}', 'Sets'),
                    const SizedBox(width: 16),
                    _buildMiniStat('${widget.exercises.length}', 'Ex'),
                  ],
                ),
              ],
            ),
          ),

          // Exercise List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...widget.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  return _buildExerciseCard(index, exercise);
                }),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _workoutComplete
          ? null
          : SizedBox(
              height: 60,
              width: 200,
              child: FloatingActionButton.extended(
                onPressed: _finishWorkout,
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.appBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                icon: Icon(Icons.check, size: 28),
                label: Text('Finish Workout', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.lime),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(int index, DayExercise exercise) {
    final sets = _completedSets[exercise.exerciseId] ?? List.filled(exercise.sets, false);
    final allSetsComplete = sets.every((s) => s);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allSetsComplete ? AppColors.lime.withOpacity(0.5) : AppColors.borderDefault.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: allSetsComplete
                        ? AppColors.lime.withOpacity(0.2)
                        : AppColors.muscleText(exercise.muscleGroup).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: allSetsComplete ? AppColors.lime : AppColors.muscleText(exercise.muscleGroup),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                          ),
                          Expanded(
                            child: Text(
                              exercise.exerciseName,
                              style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.muscleText(exercise.muscleGroup).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          exercise.muscleGroup.toUpperCase(),
                          style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muscleText(exercise.muscleGroup)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (allSetsComplete)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.lime.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.check_circle, color: AppColors.lime, size: 20),
                  ),
              ],
            ),
          ),
          // Sets Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'SETS',
                      style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1),
                    ),
                    const Spacer(),
                    Text(
                      '${sets.where((s) => s).length}/${exercise.sets} completed',
                      style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(exercise.sets, (setIndex) {
                    final isComplete = sets[setIndex];
                    return GestureDetector(
                      onTap: () => _toggleSet(exercise.exerciseId, setIndex),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isComplete ? AppColors.lime : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isComplete ? AppColors.lime : AppColors.borderDefault,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isComplete)
                              Icon(Icons.check, color: AppColors.appBg, size: 18)
                            else
                              Text(
                                '${setIndex + 1}',
                                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              '${exercise.reps} reps',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
                                color: isComplete ? AppColors.appBg : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSet(String exerciseId, int setIndex) {
    setState(() {
      final sets = _completedSets[exerciseId]!;
      sets[setIndex] = !sets[setIndex];
    });
  }

  int _getTotalCompletedSets() {
    int total = 0;
    for (final sets in _completedSets.values) {
      total += sets.where((s) => s).length;
    }
    return total;
  }

  Future<void> _finishWorkout() async {
    final completed = _completedSets.values.every((sets) => sets.every((s) => s));

    if (!completed) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Finish Workout?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          content: Text('Some sets are incomplete. Finish anyway?', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Continue', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.appBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Finish', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    setState(() => _workoutComplete = true);

    // Update all exercises with last performed date
    for (final exercise in widget.exercises) {
      try {
        await context.read<PlanProvider>().updateExerciseInDay(
              planId: widget.planId,
              weekday: widget.weekday,
              exerciseId: exercise.exerciseId,
            );
      } catch (e) {
        // Continue even if individual update fails
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.celebration, color: AppColors.appBg, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Complete!',
                    style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    _formatDuration(DateTime.now().difference(_startTime ?? DateTime.now())),
                    style: GoogleFonts.dmSans(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.lime,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
