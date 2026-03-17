class SetEntry {
  final String reps;
  final String weight;
  final bool done;

  SetEntry({
    required this.reps,
    required this.weight,
    this.done = false,
  });

  Map<String, dynamic> toMap() => {
    'reps': reps,
    'weight': weight,
    'done': done,
  };

  factory SetEntry.fromMap(Map<String, dynamic> m) => SetEntry(
    reps: m['reps'] ?? '',
    weight: m['weight'] ?? '',
    done: m['done'] ?? false,
  );
}
