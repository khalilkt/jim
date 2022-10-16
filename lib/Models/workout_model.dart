import 'dart:convert';

import 'package:jim/Models/exercise_model.dart';

class Workout {
  final String name;
  final List<Exercise> exos;

  const Workout({required this.name, required this.exos});

  Map<String, dynamic> toMap() {
    List<String> rawExos = [for (Exercise e in exos) jsonEncode(e.toMap())];
    return {
      'name': name,
      'exos': jsonEncode(rawExos),
    };
  }

  static Workout fromMap(Map<String, dynamic> map) {
    List<dynamic> rawExos = jsonDecode(map['exos']);
    return Workout(name: map['name'], exos: [
      for (var rawExo in rawExos) Exercise.fromMap(jsonDecode(rawExo))
    ]);
  }

  Workout changeOrder(int a, int b) {
    List<Exercise> newExos = List.from(exos);
    Exercise rep = newExos[a];
    newExos[a] = newExos[b];
    newExos[b] = rep;
    return Workout(name: name, exos: newExos);
  }
}

Workout pushDay = Workout(name: 'PUSH day', exos: [idp, dips, flies]);
