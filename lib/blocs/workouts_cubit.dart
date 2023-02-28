import 'dart:convert';

import 'package:bloc_exercise/models/exercise.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WorkoutsCubit extends HydratedCubit<List<Workout>> {
  WorkoutsCubit() : super([]); // initial state for this cubit

  getWorkouts() async {
    final List<Workout> workouts = [];
    final workoutsJson =
        jsonDecode(await rootBundle.loadString('assets/workouts.json'));
    for (var el in (workoutsJson as Iterable)) {
      workouts.add(Workout.fromJson(el));
    }
    emit(workouts);
  }

  saveWorkout(Workout workout, int index) {
    Workout newWorkout = Workout(title: workout.title, exercises: []);
    int exIndex = 0;
    int startTime = 0;
    for (var ex in workout.exercises) {
      newWorkout.exercises.add(Exercise(
        title: ex.title,
        prelude: ex.prelude,
        duration: ex.duration,
        index: ex.index,
        startTime: ex.startTime,
      ));
      exIndex++;
      startTime += ex.prelude! + ex.duration!;
    }

    state[index] = newWorkout;
    emit([...state]);
  }

  @override
  List<Workout>? fromJson(Map<String, dynamic> json) {
    List<Workout> workout = [];
    json['workouts'].forEach((el) => workout.add(Workout.fromJson(el)));
  }

  @override
  Map<String, dynamic>? toJson(List<Workout> state) {
    if (state is List<Workout>) {
      var json = {
        'workouts': [],
      };

      for (var workout in state) {
        json['workouts']!.add(workout.toJson());
      }

      return json;
    } else {
      return null;
    }
  }
}
