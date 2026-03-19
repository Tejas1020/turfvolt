import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/app_logger.dart';
import '../models/plan_model.dart';
import '../services/appwrite_service.dart';

/// Provider for managing workout plans with weekday-based structure
/// Supports professional trainer-style organization for clients
class PlanProvider extends ChangeNotifier {
  List<PlanModel> _plans = [];
  bool _loading = false;
  PlanModel? _currentPlan;

  List<PlanModel> get plans => _plans;
  bool get loading => _loading;
  PlanModel? get currentPlan => _currentPlan;

  /// Load all plans for a user
  Future<void> loadPlans(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final docs = await DatabaseService.getPlans(userId);
      _plans = docs.map((doc) => PlanModel.fromDoc(doc)).toList();
    } catch (e) {
      _plans = [];
    }
    _loading = false;
    notifyListeners();
  }

  /// Create a new empty plan with weekday support
  Future<PlanModel> createPlan({
    required String userId,
    required String name,
    String description = '',
  }) async {
    String? lastError;

    // Try 1: New schema with workoutDays
    try {
      final doc = await DatabaseService.createPlan({
        'userId': userId,
        'name': name,
        'description': description.isEmpty ? null : description,
        'workoutDays': [],
        'createdAt': DateTime.now().toIso8601String(),
        'isTemplate': false,
      });
      final plan = PlanModel.fromDoc(doc);
      _plans.insert(0, plan);
      notifyListeners();
      return plan;
    } catch (e) {
      lastError = e.toString();
    }

    // Try 2: Legacy schema with muscleGroup and exerciseIds
    try {
      final doc = await DatabaseService.createPlan({
        'userId': userId,
        'name': name,
        'muscleGroup': 'Full Body',
        'exerciseIds': '',
        'createdAt': DateTime.now().toIso8601String(),
      });
      final plan = PlanModel.fromDoc(doc);
      _plans.insert(0, plan);
      notifyListeners();
      return plan;
    } catch (e) {
      lastError = e.toString();
    }

    // Both attempts failed
    throw Exception('Could not create plan. Please check your Appwrite configuration. Last error: $lastError');
  }

  /// Update plan basic info
  Future<void> updatePlan(String planId, {String? name, String? description}) async {
    try {
      final plan = getPlanById(planId);
      final updatedPlan = PlanModel(
        id: planId,
        name: name ?? plan.name,
        description: description ?? plan.description,
        userId: plan.userId,
        workoutDays: plan.workoutDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Add a workout day to a plan
  Future<void> addWorkoutDay({
    required String planId,
    required Weekday weekday,
    String dayName = '',
  }) async {
    try {
      final plan = getPlanById(planId);

      // Check if day already exists
      if (plan.workoutDays.any((d) => d.weekday == weekday)) {
        throw Exception('Workout day already exists for ${weekday.displayName}');
      }

      final newDay = WorkoutDay(weekday: weekday, name: dayName);
      final updatedDays = List<WorkoutDay>.from(plan.workoutDays)..add(newDay);

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Add a workout day with exercises (copy from another day)
  Future<void> addWorkoutDayWithExercises({
    required String planId,
    required Weekday weekday,
    String dayName = '',
    List<DayExercise>? exercises,
  }) async {
    try {
      final plan = getPlanById(planId);

      // Check if day already exists
      if (plan.workoutDays.any((d) => d.weekday == weekday)) {
        throw Exception('Workout day already exists for ${weekday.displayName}');
      }

      final newDay = WorkoutDay(
        weekday: weekday,
        name: dayName,
        exercises: exercises ?? [],
      );
      final updatedDays = List<WorkoutDay>.from(plan.workoutDays)..add(newDay);

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update a workout day
  Future<void> updateWorkoutDay({
    required String planId,
    required Weekday weekday,
    String? name,
    List<DayExercise>? exercises,
    String? notes,
  }) async {
    try {
      final plan = getPlanById(planId);
      final dayIndex = plan.workoutDays.indexWhere((d) => d.weekday == weekday);

      if (dayIndex == -1) {
        throw Exception('Workout day not found for ${weekday.displayName}');
      }

      final existingDay = plan.workoutDays[dayIndex];
      final updatedDay = WorkoutDay(
        weekday: weekday,
        name: name ?? existingDay.name,
        exercises: exercises ?? existingDay.exercises,
        notes: notes ?? existingDay.notes,
      );

      final updatedDays = List<WorkoutDay>.from(plan.workoutDays);
      updatedDays[dayIndex] = updatedDay;

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove a workout day
  Future<void> removeWorkoutDay({
    required String planId,
    required Weekday weekday,
  }) async {
    try {
      final plan = getPlanById(planId);
      final updatedDays = plan.workoutDays.where((d) => d.weekday != weekday).toList();

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Add an exercise to a workout day
  Future<void> addExerciseToDay({
    required String planId,
    required Weekday weekday,
    required String exerciseId,
    required String exerciseName,
    required String muscleGroup,
    int sets = 3,
    int reps = 10,
    double? weightKg,
  }) async {
    try {
      final plan = getPlanById(planId);
      final dayIndex = plan.workoutDays.indexWhere((d) => d.weekday == weekday);

      if (dayIndex == -1) {
        throw Exception('Workout day not found for ${weekday.displayName}');
      }

      final existingDay = plan.workoutDays[dayIndex];

      // Check if exercise already exists in this day
      if (existingDay.exercises.any((e) => e.exerciseId == exerciseId)) {
        throw Exception('Exercise already added to this day');
      }

      final newExercise = DayExercise(
        exerciseId: exerciseId,
        exerciseName: exerciseName,
        muscleGroup: muscleGroup,
        sets: sets,
        reps: reps,
        weightKg: weightKg,
      );

      final updatedExercises = List<DayExercise>.from(existingDay.exercises)..add(newExercise);

      final updatedDay = WorkoutDay(
        weekday: weekday,
        name: existingDay.name,
        exercises: updatedExercises,
        notes: existingDay.notes,
      );

      final updatedDays = List<WorkoutDay>.from(plan.workoutDays);
      updatedDays[dayIndex] = updatedDay;

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Update exercise details in a workout day
  Future<void> updateExerciseInDay({
    required String planId,
    required Weekday weekday,
    required String exerciseId,
    int? sets,
    int? reps,
    double? weightKg,
    int? restSeconds,
    String? personalNotes,
    DateTime? lastPerformed,
  }) async {
    try {
      final plan = getPlanById(planId);
      final dayIndex = plan.workoutDays.indexWhere((d) => d.weekday == weekday);

      if (dayIndex == -1) {
        throw Exception('Workout day not found for ${weekday.displayName}');
      }

      final existingDay = plan.workoutDays[dayIndex];
      final exerciseIndex = existingDay.exercises.indexWhere((e) => e.exerciseId == exerciseId);

      if (exerciseIndex == -1) {
        throw Exception('Exercise not found in this day');
      }

      final existingExercise = existingDay.exercises[exerciseIndex];
      final updatedExercise = DayExercise(
        exerciseId: exerciseId,
        exerciseName: existingExercise.exerciseName,
        muscleGroup: existingExercise.muscleGroup,
        sets: sets ?? existingExercise.sets,
        reps: reps ?? existingExercise.reps,
        weightKg: weightKg ?? existingExercise.weightKg,
        restSeconds: restSeconds ?? existingExercise.restSeconds,
        personalNotes: personalNotes ?? existingExercise.personalNotes,
        prWeight: existingExercise.prWeight,
        lastPerformed: lastPerformed ?? existingExercise.lastPerformed,
      );

      final updatedExercises = List<DayExercise>.from(existingDay.exercises);
      updatedExercises[exerciseIndex] = updatedExercise;

      final updatedDay = WorkoutDay(
        weekday: weekday,
        name: existingDay.name,
        exercises: updatedExercises,
        notes: existingDay.notes,
      );

      final updatedDays = List<WorkoutDay>.from(plan.workoutDays);
      updatedDays[dayIndex] = updatedDay;

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove an exercise from a workout day
  Future<void> removeExerciseFromDay({
    required String planId,
    required Weekday weekday,
    required String exerciseId,
  }) async {
    try {
      final plan = getPlanById(planId);
      final dayIndex = plan.workoutDays.indexWhere((d) => d.weekday == weekday);

      if (dayIndex == -1) {
        throw Exception('Workout day not found for ${weekday.displayName}');
      }

      final existingDay = plan.workoutDays[dayIndex];
      final updatedExercises = existingDay.exercises.where((e) => e.exerciseId != exerciseId).toList();

      final updatedDay = WorkoutDay(
        weekday: weekday,
        name: existingDay.name,
        exercises: updatedExercises,
        notes: existingDay.notes,
      );

      final updatedDays = List<WorkoutDay>.from(plan.workoutDays);
      updatedDays[dayIndex] = updatedDay;

      final updatedPlan = PlanModel(
        id: planId,
        name: plan.name,
        description: plan.description,
        userId: plan.userId,
        workoutDays: updatedDays,
        createdAt: plan.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await DatabaseService.updatePlan(planId, updatedPlan.toMap());

      final index = _plans.indexWhere((p) => p.id == planId);
      if (index != -1) {
        _plans[index] = updatedPlan;
      }
      if (_currentPlan?.id == planId) {
        _currentPlan = updatedPlan;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a plan
  Future<void> deletePlan(String planId) async {
    try {
      await DatabaseService.deletePlan(planId);
      _plans.removeWhere((p) => p.id == planId);
      if (_currentPlan?.id == planId) {
        _currentPlan = null;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Get a plan by ID
  PlanModel getPlanById(String id) {
    return _plans.firstWhere((p) => p.id == id, orElse: () => throw Exception('Plan not found'));
  }

  /// Set the current plan for detailed viewing
  void setCurrentPlan(String? planId) {
    if (planId == null) {
      _currentPlan = null;
    } else {
      _currentPlan = getPlanById(planId);
    }
    notifyListeners();
  }

  /// Create a plan with initial workout days and exercises in one call
  /// This is the main entry point for the new plan creation workflow
  Future<PlanModel> createPlanWithDays({
    required String userId,
    required String name,
    String description = '',
    List<WorkoutDay> days = const [],
  }) async {
    // Convert days to maps for Appwrite
    final workoutDaysData = days.map((d) => d.toMap()).toList();

    // Extract all exercise IDs and muscle groups for legacy schema compatibility
    final allExerciseIds = <String>{};
    final muscleGroups = <String>{};
    for (final day in days) {
      for (final ex in day.exercises) {
        allExerciseIds.add(ex.exerciseId);
        muscleGroups.add(ex.muscleGroup);
      }
    }
    final firstMuscleGroup = muscleGroups.isNotEmpty ? muscleGroups.first : 'Full Body';

    // Build data map with only fields that exist in Appwrite schema
    final data = <String, dynamic>{
      'userId': userId,
      'name': name,
      'workoutDays': workoutDaysData,
      'muscleGroup': firstMuscleGroup,
      'exerciseIds': allExerciseIds.join(','),
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add description only if not empty (field may not exist in schema)
    if (description.isNotEmpty) {
      data['description'] = description;
    }

    try {
      final doc = await DatabaseService.createPlan(data);
      final plan = PlanModel.fromDoc(doc);
      _plans.insert(0, plan);
      notifyListeners();
      return plan;
    } catch (e) {
      AppLogger.e('ERROR creating plan: $e');
      // Re-throw with more context for debugging
      throw Exception('Failed to create plan: ${e.toString()}');
    }
  }

  /// Get plans grouped by creation date
  Map<String, List<PlanModel>> get plansByMonth {
    final result = <String, List<PlanModel>>{};
    for (final plan in _plans) {
      final date = DateTime.tryParse(plan.createdAt);
      if (date == null) continue;
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      result.putIfAbsent(key, () => []);
      result[key]!.add(plan);
    }
    return result;
  }
}
