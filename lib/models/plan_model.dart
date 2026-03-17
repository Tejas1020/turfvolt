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

  factory PlanModel.fromDoc(Map<String, dynamic> doc) => PlanModel(
    id: doc['\$id'] ?? '',
    name: doc['name'] ?? '',
    muscleGroup: doc['muscleGroup'] ?? '',
    exerciseIds: List<String>.from(doc['exerciseIds'] ?? []),
    createdAt: doc['createdAt'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'muscleGroup': muscleGroup,
    'exerciseIds': exerciseIds,
    'createdAt': createdAt,
  };
}
