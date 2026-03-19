import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/app_colors.dart';
import '../../../core/constants.dart' show builtInExercises;
import '../../../models/plan_model.dart';
import '../../../models/exercise_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/exercise_provider.dart';
import '../../../widgets/app_toast.dart';

/// Plan creation with inline exercise list grouped by muscle
class PlanCreateScreen extends StatefulWidget {
  const PlanCreateScreen({super.key});

  @override
  State<PlanCreateScreen> createState() => _PlanCreateScreenState();
}

class _PlanCreateScreenState extends State<PlanCreateScreen> {
  final _nameCtrl = TextEditingController();
  Weekday? _selectedDay;
  final _dayExercises = <Weekday, List<DayExercise>>{};
  bool _saving = false;
  String _searchQuery = '';
  String? _expandedMuscleGroup;
  List<ExerciseModel>? _exercisesCache;

  @override
  void initState() {
    super.initState();
    // Load exercises once on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ExerciseProvider>();
      setState(() {
        _exercisesCache = provider.exercises;
      });
    });
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
    if (_selectedDay == null) return;
    setState(() {
      final list = _dayExercises[_selectedDay]!;
      final existing = list.indexWhere((e) => e.exerciseId == ex.id);
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
    if (_selectedDay == null) return false;
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

    // Group by muscle
    final groups = <String, List<ExerciseModel>>{};
    for (final ex in filtered) {
      groups.putIfAbsent(ex.muscle, () => []);
      groups[ex.muscle]!.add(ex);
    }

    // Sort each group by name
    for (final key in groups.keys) {
      groups[key]!.sort((a, b) => a.name.compareTo(b.name));
    }

    return groups;
  }

  // Ordered muscle groups for consistent display
  static const _muscleOrder = [
    'Upper Chest', 'Lower Chest', 'Chest',
    'Back',
    'Shoulders',
    'Biceps', 'Triceps', 'Forearms',
    'Quads', 'Hamstrings', 'Glutes', 'Calves',
    'Core',
    'Full Body',
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

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      showToast(context, 'Enter plan name', isError: true);
      return;
    }
    if (_selectedDay == null) {
      showToast(context, 'Select a day', isError: true);
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
      final days = [WorkoutDay(
        weekday: _selectedDay!,
        name: _defaultDayName(_selectedDay!),
        exercises: exercises,
      )];

      final plan = await context.read<PlanProvider>().createPlanWithDays(
        userId: user.$id,
        name: _nameCtrl.text.trim(),
        days: days,
      );

      if (!mounted) return;
      showToast(context, 'Plan created & saved!');
      Navigator.pop(context, plan);
    } catch (e) {
      if (!mounted) return;
      showToast(context, 'Failed: ${e.toString()}', isError: true);
      setState(() => _saving = false);
    }
  }

  String _defaultDayName(Weekday d) => '${d.displayName} Workout';

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
        title: Text('New Plan', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 18)),
        actions: [
          if (!_saving)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.lime, borderRadius: BorderRadius.circular(8)),
                  child: Text('Save', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.appBg)),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Name field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameCtrl,
              autofocus: true,
              style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Plan Name',
                hintText: 'e.g., Chest & Triceps Day',
                labelStyle: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 13),
                hintStyle: GoogleFonts.dmSans(color: AppColors.textDim, fontSize: 13),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fitness_center_rounded, color: AppColors.lime, size: 22),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          // Day selector
          SizedBox(
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
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.lime, AppColors.accentDark],
                            )
                          : null,
                      color: selected ? null : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? AppColors.lime : AppColors.borderLight,
                        width: selected ? 0 : 1,
                      ),
                      boxShadow: selected ? [
                        BoxShadow(
                          color: AppColors.lime.withOpacity(0.4),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(day.icon, size: 18, color: selected ? AppColors.appBg : AppColors.textMuted),
                        const SizedBox(width: 8),
                        Text(
                          day.displayName,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? AppColors.appBg : AppColors.textPrimary,
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

          // Exercise section
          if (_selectedDay != null) ...[
            Expanded(child: _buildExerciseList()),
            _buildBottomBar(),
          ] else ...[
            Expanded(
              child: Center(
                child: Text(
                  'Select a day to add exercises',
                  style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    final grouped = _groupedExercises;
    final muscleGroups = _sortedMuscleGroups;
    final selectedExercises = _selectedDay != null ? _dayExercises[_selectedDay] ?? [] : [];

    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textDim),
            const SizedBox(height: 12),
            Text('No exercises found', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (v) => setState(() {
              _searchQuery = v;
              _expandedMuscleGroup = null; // Reset expansion on search
            }),
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              filled: true,
              fillColor: AppColors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),

        // Selected exercises summary
        if (selectedExercises.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lime.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.lime, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${selectedExercises.length} selected',
                        style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lime),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Grouped exercise list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: muscleGroups.length,
            itemBuilder: (_, i) {
              final muscle = muscleGroups[i];
              final exercises = grouped[muscle] ?? [];
              if (exercises.isEmpty) return const SizedBox.shrink();

              final isExpanded = _expandedMuscleGroup == muscle || _searchQuery.isNotEmpty;

              return _buildMuscleGroup(muscle, exercises, isExpanded);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleGroup(String muscle, List<ExerciseModel> exercises, bool isExpanded) {
    final selectedCount = exercises.where((e) => _isSelected(e)).length;
    final hasSelection = selectedCount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasSelection ? AppColors.lime.withOpacity(0.5) : AppColors.borderDefault.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Header (collapsible)
          if (_searchQuery.isEmpty)
            GestureDetector(
              onTap: () {
                setState(() {
                  _expandedMuscleGroup = isExpanded ? null : muscle;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.muscleText(muscle).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.fitness_center, color: AppColors.muscleText(muscle), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            muscle,
                            style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          Text(
                            '$exercises exercises${selectedCount > 0 ? ' • $selectedCount selected' : ''}',
                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Show muscle header when searching
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.muscleText(muscle).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.fitness_center, color: AppColors.muscleText(muscle), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    muscle,
                    style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],

          // Exercises (expanded or searching)
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: exercises.map((ex) {
                  final isSelected = _isSelected(ex);
                  return GestureDetector(
                    onTap: () => _toggleExercise(ex),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.lime.withOpacity(0.1) : AppColors.inputBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.lime : AppColors.borderDefault.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.name,
                                  style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected ? AppColors.lime : AppColors.textMuted,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalEx = _selectedDay != null ? _dayExercises[_selectedDay]?.length ?? 0 : 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_selectedDay?.displayName ?? ''}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
                Text('$totalEx exercises', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          SizedBox(
            height: 48,
            width: 140,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.appBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.appBg)))
                  : Text('Save Plan', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
