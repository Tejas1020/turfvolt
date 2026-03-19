import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Represents a professional workout plan with weekday-based structure
/// Designed for easy client use and trainer-style organization
class PlanModel {
  final String id;
  final String name;
  final String description;
  final String userId;
  final List<WorkoutDay> workoutDays;
  final String createdAt;
  final String? updatedAt;
  final bool isTemplate; // If true, this plan can be shared/reused

  PlanModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.userId,
    this.workoutDays = const [],
    required this.createdAt,
    this.updatedAt,
    this.isTemplate = false,
  });

  factory PlanModel.fromDoc(Map<String, dynamic> doc) {
    final workoutDaysRaw = doc['workoutDays'];
    List<WorkoutDay> workoutDays = [];

    if (workoutDaysRaw is List) {
      workoutDays = workoutDaysRaw
          .whereType<Map<String, dynamic>>()
          .map((day) => WorkoutDay.fromMap(day))
          .toList();
    } else if (workoutDaysRaw is String) {
      // Handle JSON string format
      try {
        final parsed = jsonDecode(workoutDaysRaw);
        if (parsed is List) {
          workoutDays = parsed
              .whereType<Map<String, dynamic>>()
              .map((day) => WorkoutDay.fromMap(day))
              .toList();
        }
      } catch (_) {}
    } else {
      // Legacy schema: convert muscleGroup and exerciseIds to WorkoutDay format
      final muscleGroup = doc['muscleGroup'] ?? 'Full Body';
      final exerciseIdsRaw = doc['exerciseIds'];
      List<String> exerciseIds = [];

      if (exerciseIdsRaw is String) {
        exerciseIds = exerciseIdsRaw.split(',').where((s) => s.isNotEmpty).toList();
      } else if (exerciseIdsRaw is List) {
        exerciseIds = exerciseIdsRaw.map((e) => e.toString()).toList();
      }

      // Create a default workout day with legacy exercises
      if (exerciseIds.isNotEmpty) {
        workoutDays = [
          WorkoutDay(
            weekday: Weekday.monday,
            name: '$muscleGroup Day',
            exercises: exerciseIds.map((id) => DayExercise(
              exerciseId: id,
              exerciseName: 'Exercise',
              muscleGroup: muscleGroup,
              sets: 3,
              reps: 10,
            )).toList(),
          ),
        ];
      }
    }

    return PlanModel(
      id: doc['\$id'] ?? doc['id'] ?? '',
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
      userId: doc['userId'] ?? '',
      workoutDays: workoutDays,
      createdAt: doc['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: doc['updatedAt'],
      isTemplate: doc['isTemplate'] == true,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'userId': userId,
    'workoutDays': workoutDays.map((d) => d.toMap()).toList(),
    'createdAt': createdAt,
    'isTemplate': isTemplate,
  };

  /// Convert to map for creating a new document (without updatedAt)
  Map<String, dynamic> toCreateMap() => {
    'name': name,
    'description': description,
    'userId': userId,
    'workoutDays': workoutDays.map((d) => d.toMap()).toList(),
    'createdAt': DateTime.now().toIso8601String(),
    'isTemplate': isTemplate,
  };

  /// Convert to map for Appwrite update (only mutable fields, workoutDays as array)
  Map<String, dynamic> toUpdateMap() => {
    'name': name,
    'description': description,
    'workoutDays': workoutDays.map((d) => d.toMap()).toList(),
    'updatedAt': DateTime.now().toIso8601String(),
  };

  /// Get total number of exercises across all days
  int get totalExercises => workoutDays.fold(0, (sum, day) => sum + day.exercises.length);

  /// Get the weekday with the most exercises
  WorkoutDay? get primaryDay {
    if (workoutDays.isEmpty) return null;
    return workoutDays.reduce((a, b) => a.exercises.length >= b.exercises.length ? a : b);
  }

  /// Backward-compatible getter for legacy code
  List<String> get exerciseIds {
    final allExerciseIds = <String>{};
    for (final day in workoutDays) {
      for (final ex in day.exercises) {
        allExerciseIds.add(ex.exerciseId);
      }
    }
    return allExerciseIds.toList();
  }

  /// Backward-compatible getter for legacy code (returns first workout day's muscle group)
  String get muscleGroup {
    if (workoutDays.isEmpty || workoutDays.first.exercises.isEmpty) return 'Full Body';
    return workoutDays.first.exercises.first.muscleGroup;
  }
}

/// Represents a single workout day (Monday-Sunday) within a plan
/// Contains exercises with sets, reps, and notes for easy tracking
class WorkoutDay {
  final Weekday weekday;
  final String name; // e.g., "Push Day", "Leg Day"
  final List<DayExercise> exercises;
  final String? notes;

  WorkoutDay({
    required this.weekday,
    this.name = '',
    this.exercises = const [],
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'weekday': weekday.index,
    'name': name,
    'exercises': exercises.map((e) => e.toMap()).toList(),
    'notes': notes ?? '',
  };

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    final weekdayIndex = map['weekday'];
    final exercisesRaw = map['exercises'];

    List<DayExercise> exercises = [];
    if (exercisesRaw is List) {
      exercises = exercisesRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => DayExercise.fromMap(e))
          .toList();
    }

    return WorkoutDay(
      weekday: Weekday.values[weekdayIndex ?? 0],
      name: map['name'] ?? '',
      exercises: exercises,
      notes: map['notes'],
    );
  }

  /// Get estimated workout duration in minutes (based on exercises count)
  int get estimatedDuration => (exercises.length * 5).clamp(15, 90);

  /// Get target muscle groups for this day
  Set<String> get targetMuscles {
    return exercises.map((e) => e.muscleGroup).whereType<String>().toSet();
  }
}

/// Represents an exercise within a workout day
/// Includes tracking info for sets, reps, weight, and personal notes
class DayExercise {
  final String exerciseId;
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double? weightKg;
  final int? restSeconds;
  final String? personalNotes;
  final double? prWeight; // Personal record
  final DateTime? lastPerformed;

  DayExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    this.sets = 3,
    this.reps = 10,
    this.weightKg,
    this.restSeconds = 60,
    this.personalNotes,
    this.prWeight,
    this.lastPerformed,
  });

  Map<String, dynamic> toMap() => {
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'muscleGroup': muscleGroup,
    'sets': sets,
    'reps': reps,
    'weightKg': weightKg,
    'restSeconds': restSeconds,
    'personalNotes': personalNotes ?? '',
    'prWeight': prWeight,
    'lastPerformed': lastPerformed?.toIso8601String(),
  };

  factory DayExercise.fromMap(Map<String, dynamic> map) {
    return DayExercise(
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      muscleGroup: map['muscleGroup'] ?? '',
      sets: map['sets'] ?? 3,
      reps: map['reps'] ?? 10,
      weightKg: map['weightKg'] != null ? (map['weightKg'] as num).toDouble() : null,
      restSeconds: map['restSeconds'],
      personalNotes: map['personalNotes'],
      prWeight: map['prWeight'] != null ? (map['prWeight'] as num?)?.toDouble() : null,
      lastPerformed: map['lastPerformed'] != null
          ? DateTime.tryParse(map['lastPerformed'])
          : null,
    );
  }

  /// Format weight for display
  String get weightDisplay {
    if (weightKg == null || weightKg! <= 0) return 'BW';
    return '${weightKg!.toStringAsFixed(1)} kg';
  }

  /// Format reps and sets for display
  String get setsRepsDisplay => '$sets x $reps';

  /// Get volume (sets x reps x weight)
  double get volume => (weightKg ?? 0) * sets * reps;
}

/// Days of the week for workout scheduling
enum Weekday {
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday'),
  sunday('Sunday');

  final String displayName;

  const Weekday(this.displayName);

  IconData get icon {
    switch (this) {
      case Weekday.monday:
        return PhosphorIcons.calendarBlank();
      case Weekday.tuesday:
        return PhosphorIcons.calendar();
      case Weekday.wednesday:
        return PhosphorIcons.calendarCheck();
      case Weekday.thursday:
        return PhosphorIcons.calendarPlus();
      case Weekday.friday:
        return PhosphorIcons.star();
      case Weekday.saturday:
        return PhosphorIcons.barbell();
      case Weekday.sunday:
        return PhosphorIcons.sun();
    }
  }

  /// Get abbreviation (e.g., "Mon")
  String get abbreviation => displayName.substring(0, 3);

  /// Get motivational message for the day
  String get motivationalMessage {
    switch (this) {
      case Weekday.monday:
        return 'Monday Motivation - Let\'s crush this week!';
      case Weekday.tuesday:
        return 'Tuesday Training - Keep the momentum!';
      case Weekday.wednesday:
        return 'Wednesday Warrior - Halfway there!';
      case Weekday.thursday:
        return 'Thursday Thrust - Push through!';
      case Weekday.friday:
        return 'Friday Finisher - End the week strong!';
      case Weekday.saturday:
        return 'Saturday Strength - Weekend gains!';
      case Weekday.sunday:
        return 'Sunday Session - Ready for the week ahead!';
    }
  }
}
