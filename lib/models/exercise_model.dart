class ExerciseModel {
  final String id;
  final String name;
  final String muscle;
  final String desc;
  final String icon;
  final bool isCustom;
  final String? docId;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.muscle,
    required this.desc,
    required this.icon,
    this.isCustom = false,
    this.docId,
  });

  factory ExerciseModel.fromBuiltIn(Map<String, String> data) => ExerciseModel(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    muscle: data['muscle'] ?? '',
    desc: data['desc'] ?? '',
    icon: data['icon'] ?? '💪',
    isCustom: false,
  );

  factory ExerciseModel.fromCustom(Map<String, dynamic> data, String docId) => ExerciseModel(
    id: docId,
    name: data['name'] ?? '',
    muscle: data['muscleGroup'] ?? '',
    desc: data['description'] ?? '',
    icon: '✨',
    isCustom: true,
    docId: docId,
  );
}
