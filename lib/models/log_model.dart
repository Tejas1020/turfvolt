import 'dart:convert';
import 'set_entry_model.dart';

class LogModel {
  final String id;
  final String planId;
  final String exerciseId;
  final String exerciseName;
  final String muscleGroup;
  final String date;
  final List<SetEntry> sets;
  final String notes;

  LogModel({
    required this.id,
    required this.planId,
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.date,
    required this.sets,
    this.notes = '',
  });

  factory LogModel.fromDoc(Map<String, dynamic> doc) {
    final rawSets = doc['sets'];
    List<SetEntry> sets = [];
    if (rawSets is List) {
      sets = rawSets.map((s) {
        final map = s is String ? jsonDecode(s) : s as Map<String, dynamic>;
        return SetEntry.fromMap(map);
      }).toList();
    } else if (rawSets is String) {
      final decoded = jsonDecode(rawSets) as List;
      sets = decoded.map((s) => SetEntry.fromMap(s as Map<String, dynamic>)).toList();
    }
    return LogModel(
      id: doc['\$id'] ?? '',
      planId: doc['planId'] ?? '',
      exerciseId: doc['exerciseId'] ?? '',
      exerciseName: doc['exerciseName'] ?? '',
      muscleGroup: doc['muscleGroup'] ?? '',
      date: doc['date'] ?? '',
      sets: sets,
      notes: doc['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'planId': planId,
    'exerciseId': exerciseId,
    'exerciseName': exerciseName,
    'muscleGroup': muscleGroup,
    'date': date,
    'sets': sets.map((s) => s.toMap()).toList(),
    'notes': notes,
  };
}
