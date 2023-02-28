import 'package:bloc_exercise/models/workout.dart';
import 'package:equatable/equatable.dart';

abstract class WorkoutState extends Equatable {
  final Workout? workout;
  final int? elapsed;
  const WorkoutState(this.workout, this.elapsed);
}

class WorkoutInitial extends WorkoutState {
  const WorkoutInitial() : super(null, 0);

  @override
  List<Object?> get props => [];
}

class WorkoutEditting extends WorkoutState {
  final int index;
  final int? exIndex;
  const WorkoutEditting(this.exIndex, this.index, Workout? workout)
      : super(workout, 0);

  @override
  List<Object?> get props => [workout, index, exIndex];
}

class WorkoutInProgress extends WorkoutState {
  const WorkoutInProgress(Workout? workout, int? elapsed)
      : super(workout, elapsed);

  @override
  List<Object?> get props => [workout, elapsed];
}

class WorkoutPaused extends WorkoutState {
  const WorkoutPaused(Workout? workout, int? elapsed) : super(workout, elapsed);

  @override
  List<Object?> get props => [workout, elapsed];
}
