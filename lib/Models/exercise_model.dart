class Exercise {
  final String name;
  final int sets;
  final int reps;
  final double? weight;

  const Exercise(
      {required this.name,
      required this.sets,
      required this.reps,
      required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
    );
  }

  Exercise copyWith({
    String? name,
    int? sets,
    int? reps,
  }) {
    return Exercise(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight,
    );
  }

  Exercise copyWithWeight(double? weight) {
    return Exercise(name: name, sets: sets, reps: reps, weight: weight);
  }
}

Exercise idp = const Exercise(
  name: 'Inclined Dumbell Press',
  sets: 4,
  reps: 12,
  weight: 27.5,
);

Exercise dips = const Exercise(name: 'Dips', sets: 4, reps: 12, weight: null);

Exercise flies = const Exercise(name: 'Flies', sets: 4, reps: 20, weight: 9.0);
