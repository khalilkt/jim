import 'package:bloc/bloc.dart';

part 'workout_state.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit() : super(WorkoutState());
}
