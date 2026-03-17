import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../core/constants.dart' as constants;
import '../services/appwrite_service.dart';

class ExerciseProvider extends ChangeNotifier {
  List<ExerciseModel> _exercises = [];
  List<ExerciseModel> _customExercises = [];
  bool _loading = false;

  List<ExerciseModel> get exercises => [..._exercises, ..._customExercises];
  List<ExerciseModel> get builtInExercises => _exercises;
  List<ExerciseModel> get customExercises => _customExercises;
  bool get loading => _loading;

  void loadBuiltInExercises() {
    _exercises = constants.builtInExercises
        .map((data) => ExerciseModel.fromBuiltIn(data))
        .toList();
    notifyListeners();
  }

  Future<void> loadCustomExercises(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final docs = await DatabaseService.getCustomExercises(userId);
      _customExercises = docs
          .map((doc) => ExerciseModel.fromCustom(doc, doc['\$id'] ?? ''))
          .toList();
    } catch (e) {
      // Handle error silently
      _customExercises = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addCustomExercise({
    required String userId,
    required String name,
    required String muscle,
    required String description,
  }) async {
    try {
      final doc = await DatabaseService.createCustomExercise({
        'userId': userId,
        'name': name,
        'muscleGroup': muscle,
        'description': description,
        'isCustom': true,
      });
      _customExercises.insert(
        0,
        ExerciseModel.fromCustom(doc, doc['\$id'] ?? ''),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCustomExercise(String exerciseId) async {
    try {
      await DatabaseService.deleteCustomExercise(exerciseId);
      _customExercises.removeWhere((e) => e.docId == exerciseId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  ExerciseModel? getExerciseById(String id) {
    return exercises.firstWhere((e) => e.id == id, orElse: () => throw Exception('Exercise not found'));
  }
}
