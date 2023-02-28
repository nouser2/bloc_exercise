import 'package:bloc_exercise/models/exercise.dart';
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String? title;
  final List<Exercise> exercises;

  const Workout({
    required this.exercises,
    required this.title,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercise> exercises = [];
    int index = 0;
    int startTime = 0;
    for (var ex in json['exercises'] as Iterable) {
      exercises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      print('... $index ....');
      startTime += exercises.last.prelude! + exercises.last.duration!;
    }

    return Workout(exercises: exercises, title: json['title'] as String);
  }

  int getTotal() {
    int time = exercises.fold(
        0,
        (previousValue, exercise) =>
            previousValue + exercise.duration! + exercise.prelude!);
    return time;
  }

  Exercise getCurrentExercise(int? elasped) {
    return exercises.lastWhere((element) => element.startTime! <= elasped!);
  }

  copyWith({String? title}) =>
      Workout(exercises: exercises, title: title ?? this.title);

  Map<String, dynamic> toJson() => {'title': title, 'exercises': exercises};

  @override
  List<Object?> get props => [exercises, title];

  @override
  bool get stringify => true;
}
