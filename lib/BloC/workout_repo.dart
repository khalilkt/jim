import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../constants.dart';
import '../Models/workout_model.dart';

const String workoutRepoDep = 'WORKOUT-REPO';

class WorkoutRepo {
  late Database db;
  final String _workoutTable = 'WORKOUTS';
  bool inited = false;

  Future<void> init() async {
    log('initing...', workoutRepoDep);
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'db.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        log('db on create', workoutRepoDep);
        await _createWorkoutTable(db);
      },
    );
    inited = true;
  }

  Future<void> _createWorkoutTable(Database db) async {
    log('Creating XWorkout table', workoutRepoDep);
    await db.execute("DROP TABLE IF EXISTS $_workoutTable");
    await db.execute(
        'CREATE TABLE $_workoutTable (id INTEGER PRIMARY KEY, name TEXT,  exos TEXT)');
  }

  Future<List<Workout>> loadWorkouts() async {
    if (!inited) {
      await init();
    }
    log('Loading workout', workoutRepoDep);
    List<Workout> ret = [];
    var l = await db.query(_workoutTable);
    for (var rawWorkout in l) {
      ret.add(Workout.fromMap(rawWorkout));
    }

    return ret;
  }

  Future<void> save(
    List<Workout> workouts,
  ) async {
    if (!inited) {
      await init();
    }
    log('saving workout', workoutRepoDep);
    try {
      await db.delete(_workoutTable);
    } catch (e) {
      await _createWorkoutTable(db);
    }
    for (var d in workouts) {
      db.insert(_workoutTable, d.toMap());
    }
  }
}
