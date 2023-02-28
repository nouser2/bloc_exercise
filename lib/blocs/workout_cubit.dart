import 'dart:async';

import 'package:bloc_exercise/models/workout.dart';
import 'package:bloc_exercise/states/workout_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit() : super(const WorkoutInitial());

  Timer? _timer;

  editWorkout(Workout workout, int index) =>
      emit(WorkoutEditting(null, index, workout));

  editExercise(int? exIndex) => emit(WorkoutEditting(
      exIndex, (state as WorkoutEditting).index, state.workout));

  goHome() {
    emit(const WorkoutInitial());
  }

  pauseWorkout() => emit(WorkoutPaused(state.workout, state.elapsed));

  resumeWorkout() => emit(WorkoutInProgress(state.workout, state.elapsed));

  void tick(timer) {
    if (state is WorkoutInProgress) {
      WorkoutInProgress wkp = state as WorkoutInProgress;
      if (wkp.elapsed! < wkp.workout!.getTotal()) {
        emit(WorkoutInProgress(wkp.workout, wkp.elapsed! + 1));
      } else {
        _timer!.cancel();
        Wakelock.disable();
        emit(const WorkoutInitial());
      }
    }
  }

  startWorkout(Workout workout, [int? index]) {
    Wakelock.enable();
    if (index != null) {
    } else {
      emit(WorkoutInProgress(workout, 0));
      _timer = Timer.periodic(const Duration(seconds: 1), tick);
    }
  }
}
