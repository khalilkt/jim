part of 'workout_cubit.dart';

class WorkoutState {
  final List<Workout> workouts;
  const WorkoutState(this.workouts);

  WorkoutState copyWith({List<Workout>? workouts}) {
    return WorkoutState(workouts ?? this.workouts);
  }
}
