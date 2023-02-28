import 'package:bloc_exercise/blocs/workout_cubit.dart';
import 'package:bloc_exercise/blocs/workouts_cubit.dart';
import 'package:bloc_exercise/helpers/helpers.dart';
import 'package:bloc_exercise/models/exercise.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:bloc_exercise/screens/edit_exercise_screen.dart';
import 'package:bloc_exercise/states/workout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => BlocProvider.of<WorkoutCubit>(context).goHome(),
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (_, state) {
            WorkoutEditting workoutEditting = state as WorkoutEditting;
            return Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    onPressed: () =>
                        BlocProvider.of<WorkoutCubit>(context).goHome(),
                  ),
                  title: InkWell(
                    child: Text(workoutEditting.workout!.title!),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            final controller = TextEditingController(
                                text: workoutEditting.workout!.title);

                            return AlertDialog(
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                    labelText: 'Workout Title'),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      if (controller.text.isNotEmpty) {
                                        Navigator.pop(context);
                                        Workout renamed = workoutEditting
                                            .workout!
                                            .copyWith(title: controller.text);

                                        BlocProvider.of<WorkoutsCubit>(context)
                                            .saveWorkout(
                                                renamed, workoutEditting.index);

                                        BlocProvider.of<WorkoutCubit>(context)
                                            .editWorkout(
                                                renamed, workoutEditting.index);
                                      }
                                    },
                                    child: Text('rename')),
                              ],
                            );
                          });
                    },
                  ),
                ),
                body: ListView.builder(
                  itemCount: workoutEditting.workout!.exercises.length,
                  itemBuilder: (context, index) {
                    Exercise exercise =
                        workoutEditting.workout!.exercises[index];

                    if (workoutEditting.exIndex == index) {
                      return EditExerciseScreen(
                          workout: workoutEditting.workout,
                          index: workoutEditting.index,
                          exIndex: workoutEditting.exIndex);
                    }

                    return ListTile(
                      onTap: () {
                        BlocProvider.of<WorkoutCubit>(context)
                            .editExercise(index);

                       
                      },
                      leading: Text(formatTime(exercise.prelude!, true)),
                      title: Text(exercise.title!),
                      trailing: Text(formatTime(exercise.duration!, true)),
                    );
                  },
                ));
          },
        ));
  }
}
