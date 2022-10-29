import 'package:bloc/bloc.dart';
import 'package:jim/BloC/workout_repo.dart';
import 'package:jim/Models/ui_exception.dart';
import 'package:jim/constants.dart';

import '../Models/exercise_model.dart';
import '../Models/workout_model.dart';

part 'workout_state.dart';

String dep = 'WORKOUTCUBIT';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutRepo repo = WorkoutRepo();

  WorkoutCubit() : super(const WorkoutState([]));

  // Future<void> _init() async {
  //   await repo.init();
  // }

  Future<void> init() async {
    log('init cubit', dep);
    if (!repo.inited) {
      await repo.init();
      List<Workout> wws = await repo.loadWorkouts();
      emit(WorkoutState(wws));
    }
  }

  Future<void> save() async {
    if (!repo.inited) {
      throw Exception(
          'save called before initing the repo'); //to not save empty state
    }
    await repo.save(state.workouts);
  }

  Future<void> createWorkout(
      {required String name, required List<Exercise> exos}) async {
    if (state.workouts.where((element) => element.name == name).isNotEmpty) {
      throw NameAlreadyUsedException;
    }
    List<Workout> newWW = List.from(state.workouts);
    newWW.add(Workout(name: name, exos: exos));
    emit(state.copyWith(workouts: newWW));
    await save();
  }
}

class NameAlreadyUsedException extends UiException {
  const NameAlreadyUsedException()
      : super('This name is already used', UiExceptionType.error);
}
