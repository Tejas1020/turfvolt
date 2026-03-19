import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ExerciseModel {
  final String id;
  final String name;
  final String muscle;
  final String desc;
  final IconData icon;
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

  static IconData _getIconData(String? iconKey) {
    switch (iconKey) {
      case 'chest':
        return PhosphorIcons.barbell();
      case 'back':
        return PhosphorIcons.barbell();
      case 'shoulders':
        return PhosphorIcons.barbell();
      case 'arms':
        return PhosphorIcons.armchair();
      case 'legs':
        return PhosphorIcons.footprints();
      case 'core':
        return PhosphorIcons.target();
      default:
        return PhosphorIcons.barbell();
    }
  }

  factory ExerciseModel.fromBuiltIn(Map<String, String> data) => ExerciseModel(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    muscle: data['muscle'] ?? '',
    desc: data['desc'] ?? '',
    icon: _getIconData(data['icon']),
    isCustom: false,
  );

  factory ExerciseModel.fromCustom(Map<String, dynamic> data, String docId) => ExerciseModel(
    id: docId,
    name: data['name'] ?? '',
    muscle: data['muscleGroup'] ?? '',
    desc: data['description'] ?? '',
    icon: PhosphorIcons.sparkle(),
    isCustom: true,
    docId: docId,
  );
}
