import 'package:flutter/foundation.dart';
import '../models/log_model.dart';
import '../services/appwrite_service.dart';

class LogProvider extends ChangeNotifier {
  List<LogModel> _logs = [];
  bool _loading = false;

  List<LogModel> get logs => _logs;
  bool get loading => _loading;

  Future<void> loadLogs(String userId) async {
    _loading = true;
    notifyListeners();
    try {
      final docs = await DatabaseService.getLogs(userId);
      _logs = docs.map((doc) => LogModel.fromDoc(doc)).toList();
    } catch (e) {
      _logs = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> createLog({
    required String userId,
    required String planId,
    required String exerciseId,
    required String exerciseName,
    required String muscleGroup,
    required String date,
    required List<dynamic> sets,
    String notes = '',
  }) async {
    try {
      final doc = await DatabaseService.createLog({
        'userId': userId,
        'planId': planId,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'muscleGroup': muscleGroup,
        'date': date,
        'sets': sets,
        'notes': notes,
      });
      _logs.insert(0, LogModel.fromDoc(doc));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Computed getters used by UI
  List<LogModel> get todayLogs {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _logs.where((l) => l.date == today).toList();
  }

  int get exercisesLoggedToday {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _logs.where((l) => l.date == today).length;
  }

  int get setsDoneToday {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _logs
        .where((l) => l.date == today)
        .fold(0, (sum, l) => sum + l.sets.where((s) => s.done).length);
  }

  double get volumeToday {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return _logs
        .where((l) => l.date == today)
        .fold(0.0, (sum, l) => sum +
            l.sets.where((s) => s.done).fold(
              0.0,
              (setSum, s) => setSum + (double.tryParse(s.weight) ?? 0) * (int.tryParse(s.reps) ?? 0),
            ));
  }

  int get currentStreak {
    final dates = _logs.map((l) => l.date).toSet().toList()..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime d = DateTime.now();
    for (final date in dates) {
      final ds = d.toIso8601String().split('T')[0];
      if (date == ds) {
        streak++;
        d = d.subtract(const Duration(days: 1));
      } else if (date.compareTo(ds) < 0) {
        break;
      }
    }
    return streak;
  }

  int get totalActiveDays {
    return _logs.map((l) => l.date).toSet().length;
  }

  double get consistencyPercentage {
    if (_logs.isEmpty) return 0.0;
    final last16Weeks = List.generate(112, (i) {
      return DateTime.now().subtract(Duration(days: 111 - i)).toIso8601String().split('T')[0];
    });
    final activeDates = _logs.map((l) => l.date).toSet();
    final activeDaysInPeriod = last16Weeks.where((d) => activeDates.contains(d)).length;
    return (activeDaysInPeriod / 112) * 100;
  }

  List<LogModel> getLogsByDateRange(DateTime start, DateTime end) {
    final startStr = start.toIso8601String().split('T')[0];
    final endStr = end.toIso8601String().split('T')[0];
    return _logs.where((l) {
      final date = l.date;
      return date.compareTo(startStr) >= 0 && date.compareTo(endStr) <= 0;
    }).toList();
  }
}
