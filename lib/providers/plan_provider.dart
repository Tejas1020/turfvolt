import 'package:flutter/foundation.dart';
import '../models/plan_model.dart';
import '../services/appwrite_service.dart';

class PlanProvider extends ChangeNotifier {
  List<PlanModel> _plans = [];
  bool _loading = false;

  List<PlanModel> get plans => _plans;
  bool get loading => _loading;

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

  Future<void> createPlan({
    required String userId,
    required String name,
    required String muscleGroup,
    required List<String> exerciseIds,
  }) async {
    try {
      final doc = await DatabaseService.createPlan({
        'userId': userId,
        'name': name,
        'muscleGroup': muscleGroup,
        'exerciseIds': exerciseIds.join(','), // Store as comma-separated string
        'createdAt': DateTime.now().toIso8601String(),
      });
      _plans.insert(0, PlanModel.fromDoc(doc));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await DatabaseService.deletePlan(planId);
      _plans.removeWhere((p) => p.id == planId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  PlanModel? getPlanById(String id) {
    return _plans.firstWhere((p) => p.id == id, orElse: () => throw Exception('Plan not found'));
  }
}
