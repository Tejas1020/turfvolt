class PlanModel {
  final String id;
  final String name;
  final String muscleGroup;
  final List<String> exerciseIds;
  final String createdAt;

  PlanModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.exerciseIds,
    required this.createdAt,
  });

  factory PlanModel.fromDoc(Map<String, dynamic> doc) {
    // exerciseIds is stored as comma-separated string in Appwrite
    final exerciseIdsRaw = doc['exerciseIds'];
    List<String> exerciseIds = [];
    if (exerciseIdsRaw is String) {
      exerciseIds = exerciseIdsRaw.split(',').where((s) => s.isNotEmpty).toList();
    } else if (exerciseIdsRaw is List) {
      exerciseIds = exerciseIdsRaw.map((e) => e.toString()).toList();
    }
    return PlanModel(
      id: doc['\$id'] ?? '',
      name: doc['name'] ?? '',
      muscleGroup: doc['muscleGroup'] ?? '',
      exerciseIds: exerciseIds,
      createdAt: doc['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'muscleGroup': muscleGroup,
    'exerciseIds': exerciseIds,
    'createdAt': createdAt,
  };
}
