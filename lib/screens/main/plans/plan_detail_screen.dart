import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/app_colors.dart';
import '../../../models/plan_model.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../widgets/app_toast.dart';
import 'workout_track_screen.dart';

/// Plan detail screen - manage workout days and exercises
/// Users can add/remove days and exercises for their plan
class PlanDetailScreen extends StatefulWidget {
  final String planId;

  const PlanDetailScreen({super.key, required this.planId});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  @override
  void initState() {
    super.initState();
    _refreshPlan();
  }

  void _refreshPlan() {
    // Rebuild by reading the current plan state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final plansP = context.watch<PlanProvider>();
    PlanModel plan;

    try {
      plan = plansP.getPlanById(widget.planId);
    } catch (e) {
      return Scaffold(
        backgroundColor: AppColors.appBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardBg,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text('Plan not found', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        backgroundColor: AppColors.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          plan.name,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.coral),
            onPressed: () => _confirmDelete(context, plan),
            tooltip: 'Delete plan',
          ),
        ],
      ),
      body: Column(
        children: [
          // Plan Header Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.lime.withOpacity(0.15), AppColors.lime.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lime.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lime.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.fitness_center, color: AppColors.lime, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          if (plan.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              plan.description,
                              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatChip('${plan.workoutDays.length}', 'Days', Icons.calendar_today),
                    const SizedBox(width: 12),
                    _buildStatChip('${plan.totalExercises}', 'Exercises', Icons.fitness_center),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      '${plan.workoutDays.fold<int>(0, (sum, day) => sum + day.exercises.length * day.estimatedDuration)} min',
                      'Est. Time',
                      Icons.timer,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Weekdays Section - Only show assigned days
          Expanded(
            child: plan.workoutDays.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No workout days yet',
                          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a workout day to get started',
                          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WORKOUT DAYS',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...plan.workoutDays.map((day) => _buildAssignedDayTile(plan, day)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
          ),

        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Text(
                label,
                style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedDayTile(PlanModel plan, WorkoutDay day) {
    final weekday = day.weekday;
    final hasExercises = day.exercises.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: hasExercises ? AppColors.cardBg : AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasExercises ? AppColors.lime.withOpacity(0.3) : AppColors.borderDefault.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Day Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Day icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasExercises
                        ? AppColors.lime.withOpacity(0.2)
                        : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    weekday.icon,
                    size: 20,
                    color: AppColors.lime,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Day name + badge row
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              weekday.displayName,
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: hasExercises ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (day.name.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.lime.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  day.name,
                                  style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.lime),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasExercises
                            ? '${day.exercises.length} exercises • ~${day.estimatedDuration} min'
                            : 'No exercises yet',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: hasExercises ? AppColors.textMuted : AppColors.textMuted.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Action buttons
                SizedBox(
                  width: 72,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.edit, color: AppColors.textMuted, size: 18),
                          onPressed: () => _editDayName(plan, day),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.coral, size: 20),
                          onPressed: () => _removeDay(plan, weekday),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Exercises Preview
          if (hasExercises) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: day.exercises.map((ex) {
                  return _ExerciseChip(
                    exercise: ex,
                    onRemove: () => _removeExercise(plan, weekday, ex),
                  );
                }).toList(),
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutTrackScreen(
                              planId: plan.id,
                              weekday: weekday,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.lime,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.lime.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 18, color: AppColors.lime),
                          const SizedBox(width: 6),
                          Text(
                            'Start Workout',
                            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.lime),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showAddExerciseDialog(plan, weekday),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lime,
                      foregroundColor: AppColors.appBg,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
          ],
          // Empty State - Add Exercises CTA
          if (!hasExercises) ...[
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddExerciseDialog(plan, weekday),
                  icon: Icon(Icons.add, color: AppColors.lime),
                  label: Text(
                    'Add Exercises',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.lime),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.lime,
                    side: BorderSide(color: AppColors.lime.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayTile(PlanModel plan, Weekday weekday) {
    final day = plan.workoutDays.firstWhere(
      (d) => d.weekday == weekday,
      orElse: () => WorkoutDay(weekday: weekday),
    );

    final hasExercises = day.exercises.isNotEmpty;
    final existsInPlan = plan.workoutDays.any((d) => d.weekday == weekday);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: hasExercises ? AppColors.cardBg : AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasExercises ? AppColors.lime.withOpacity(0.3) : AppColors.borderDefault.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Day Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Day icon - fixed size
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hasExercises
                        ? AppColors.lime.withOpacity(0.2)
                        : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    weekday.icon,
                    size: 20,
                    color: AppColors.lime,
                  ),
                ),
                const SizedBox(width: 12),
                // Content - flexible with constraints
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Day name + badge row
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              weekday.displayName,
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: hasExercises ? AppColors.textPrimary : AppColors.textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (existsInPlan && day.name.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.lime.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  day.name,
                                  style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.lime),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasExercises
                            ? '${day.exercises.length} exercises • ~${day.estimatedDuration} min'
                            : 'No exercises yet',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: hasExercises ? AppColors.textMuted : AppColors.textMuted.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Action buttons - fixed size
                SizedBox(
                  width: 72,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (existsInPlan) ...[
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.edit, color: AppColors.textMuted, size: 18),
                            onPressed: () => _editDayName(plan, day),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.delete_outline, color: AppColors.coral, size: 20),
                            onPressed: () => _removeDay(plan, weekday),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.add_circle_outline, color: AppColors.lime, size: 20),
                            onPressed: () => _addDay(plan, weekday),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Exercises Preview
          if (hasExercises) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: day.exercises.take(3).map((ex) {
                  return SizedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ex.exerciseName,
                        style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutTrackScreen(
                              planId: plan.id,
                              weekday: weekday,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.lime,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColors.lime.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 18, color: AppColors.lime),
                          const SizedBox(width: 6),
                          Text(
                            'Start Workout',
                            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.lime),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showAddExerciseDialog(plan, weekday),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lime,
                      foregroundColor: AppColors.appBg,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
          ],
          // Empty State - Add Exercises CTA
          if (!hasExercises && existsInPlan) ...[
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddExerciseDialog(plan, weekday),
                  icon: Icon(Icons.add, color: AppColors.lime),
                  label: Text(
                    'Add Exercises',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.lime),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.lime,
                    side: BorderSide(color: AppColors.lime.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _addDay(PlanModel plan, Weekday weekday) async {
    try {
      await context.read<PlanProvider>().addWorkoutDay(
        planId: plan.id,
        weekday: weekday,
      );
      showToast(context, '${weekday.displayName} added');
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }

  Future<void> _removeDay(PlanModel plan, Weekday weekday) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove ${weekday.displayName}?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: Text(
          'This will remove all exercises for this day. Cannot be undone.',
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
            child: Text('Remove', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<PlanProvider>().removeWorkoutDay(
        planId: plan.id,
        weekday: weekday,
      );
      showToast(context, '${weekday.displayName} removed');
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }

  Future<void> _editDayName(PlanModel plan, WorkoutDay day) async {
    final nameCtrl = TextEditingController(text: day.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Day Name', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: nameCtrl,
          style: GoogleFonts.dmSans(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'e.g., Push Day, Leg Day',
            hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, nameCtrl.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: AppColors.appBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Save', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    try {
      await context.read<PlanProvider>().updateWorkoutDay(
        planId: plan.id,
        weekday: day.weekday,
        name: result,
      );
      showToast(context, 'Day name updated');
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }

  Future<void> _removeExercise(PlanModel plan, Weekday weekday, DayExercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove ${exercise.exerciseName}?', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        content: Text(
          'This will remove the exercise from ${weekday.displayName}.',
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
            child: Text('Remove', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context.read<PlanProvider>().removeExerciseFromDay(
        planId: plan.id,
        weekday: weekday,
        exerciseId: exercise.exerciseId,
      );
      showToast(context, '${exercise.exerciseName} removed');
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }

  Future<void> _showAddExerciseDialog(PlanModel plan, Weekday weekday) async {
    final exerciseProvider = context.read<ExerciseProvider>();
    final allExercises = exerciseProvider.exercises;

    final day = plan.workoutDays.firstWhere(
      (d) => d.weekday == weekday,
      orElse: () => WorkoutDay(weekday: weekday),
    );

    final existingExerciseIds = day.exercises.map((e) => e.exerciseId).toSet();

    final result = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (ctx) => _ExercisePickerDialog(
        exercises: allExercises,
        selectedExercises: existingExerciseIds,
      ),
    );

    if (result == null || result.isEmpty) return;

    for (final exerciseData in result) {
      if (existingExerciseIds.contains(exerciseData['id'])) continue;

      try {
        await context.read<PlanProvider>().addExerciseToDay(
          planId: plan.id,
          weekday: weekday,
          exerciseId: exerciseData['id'] ?? '',
          exerciseName: exerciseData['name'] ?? '',
          muscleGroup: exerciseData['muscle'] ?? 'Full Body',
          sets: 3,
          reps: 10,
        );
      } catch (e) {
        // Continue adding other exercises
      }
    }

    showToast(context, 'Exercises added to ${weekday.displayName}');
  }

  Future<void> _confirmDelete(BuildContext context, PlanModel plan) async {
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
      Navigator.pop(context);
    } catch (e) {
      showToast(context, e.toString(), isError: true);
    }
  }
}

/// Exercise chip with remove button
class _ExerciseChip extends StatelessWidget {
  final DayExercise exercise;
  final VoidCallback onRemove;

  const _ExerciseChip({
    required this.exercise,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 2, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            exercise.exerciseName,
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.coral.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.close,
                size: 12,
                color: AppColors.coral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Exercise picker dialog (same as in plan_create_screen.dart)
class _ExercisePickerDialog extends StatefulWidget {
  final List<ExerciseModel> exercises;
  final Set<String> selectedExercises;

  const _ExercisePickerDialog({
    required this.exercises,
    required this.selectedExercises,
  });

  @override
  State<_ExercisePickerDialog> createState() => _ExercisePickerDialogState();
}

class _ExercisePickerDialogState extends State<_ExercisePickerDialog> {
  final Set<String> _tempSelected = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelected.addAll(widget.selectedExercises);
  }

  List<ExerciseModel> get _filteredExercises {
    if (_searchQuery.isEmpty) return widget.exercises;
    final query = _searchQuery.toLowerCase();
    return widget.exercises.where((e) {
      return e.name.toLowerCase().contains(query) ||
             e.muscle.toLowerCase().contains(query);
    }).toList();
  }

  void _toggleExercise(String id) {
    setState(() {
      if (_tempSelected.contains(id)) {
        _tempSelected.remove(id);
      } else {
        _tempSelected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exercises',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.dmSans(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              hintStyle: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._filteredExercises.map((exercise) {
                  final isSelected = _tempSelected.contains(exercise.id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.muscleText(exercise.muscle).withOpacity(0.2),
                      child: Icon(exercise.icon, size: 18, color: AppColors.textPrimary),
                    ),
                    title: Text(
                      exercise.name,
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Text(
                      exercise.muscle,
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? AppColors.lime : AppColors.textMuted,
                    ),
                    onTap: () => _toggleExercise(exercise.id),
                    selected: isSelected,
                    selectedTileColor: AppColors.lime.withOpacity(0.1),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final selectedData = widget.exercises
                .where((e) => _tempSelected.contains(e.id))
                .map((e) => {
                      'id': e.id,
                      'name': e.name,
                      'muscle': e.muscle,
                      'icon': e.icon,
                    })
                .toList();
            Navigator.pop(context, selectedData);
          },
          icon: Icon(Icons.check, color: AppColors.appBg),
          label: Text(
            'Add ${_tempSelected.length} Exercises',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lime,
            foregroundColor: AppColors.appBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
