import 'package:bloc_exercise/blocs/workout_cubit.dart';
import 'package:bloc_exercise/helpers/helpers.dart';
import 'package:bloc_exercise/models/exercise.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:bloc_exercise/states/workout_states.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class WorkoutInProgressScreen extends StatelessWidget {
  const WorkoutInProgressScreen({super.key});
  Map<String, dynamic> _getStats(Workout workout, int workoutElapsed) {
    int workoutTotal = workout.getTotal();
    Exercise exercise = workout.getCurrentExercise(workoutElapsed);
    int exerciseElapsed = workoutElapsed - exercise.startTime!;
    int exerciseRemaining = exercise.prelude! - exerciseElapsed;
    bool isPrelude = exerciseElapsed < exercise.prelude!;
    int exerciseTotal = isPrelude ? exercise.prelude! : exercise.duration!;

    if (!isPrelude) {
      exerciseElapsed -= exercise.prelude!;
      exerciseRemaining += exercise.duration!;
    }

    //  print('${}');
    return {
      "workoutProgressPrelude": exerciseElapsed / exerciseTotal,
      "workoutTitle": workout.title,
      'workoutProgressTotal': workoutElapsed / workoutTotal,
      "workoutElapsed": workoutElapsed,
      "totalExercise": workout.exercises.length,
      'currentExerciseIndexInt': exercise.index!,
      'currentExerciseIndex': exercise.index!.toDouble(),
      "workoutRemaining": workoutTotal - workoutElapsed,
      "exerciseRemaining": exerciseRemaining,
      'isPrelude': isPrelude
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        final stats = _getStats(state.workout!, state.elapsed!);
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => BlocProvider.of<WorkoutCubit>(context).goHome(),
            ),
            title: Text(state.workout!.title!),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[300],
                  minHeight: 10,
                  value: stats['workoutProgressTotal'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(stats['workoutElapsed'], true)),
                      DotsIndicator(
                        dotsCount: stats['totalExercise'],
                        position: stats['currentExerciseIndex'],
                      ),
                      Text('-${formatTime(stats['workoutRemaining'], true)}')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                // name of exercise
                !stats['isPrelude']
                    ? Center(
                        child: Text(
                          state
                              .workout!
                              .exercises[stats['currentExerciseIndexInt']]
                              .title!,
                          style: const TextStyle(fontSize: 30),
                        ),
                      )
                    : Center(
                        child: Column(
                          children: [
                            const Text(
                              'Get Ready for',
                              style: TextStyle(color: Colors.red, fontSize: 25),
                            ),
                            Text(
                              state
                                  .workout!
                                  .exercises[(stats['currentExerciseIndexInt'])]
                                  .title!,
                              style: const TextStyle(fontSize: 30),
                            )
                          ],
                        ),
                      ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (state is WorkoutInProgress) {
                      BlocProvider.of<WorkoutCubit>(context).pauseWorkout();
                    } else {
                      if (state is WorkoutPaused) {
                        BlocProvider.of<WorkoutCubit>(context).resumeWorkout();
                      }
                    }
                  },
                  child: Stack(
                    alignment: const Alignment(0, 0),
                    children: [
                      Center(
                        child: SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                stats['isPrelude'] ? Colors.red : Colors.blue),
                            strokeWidth: 25,
                            value: stats['workoutProgressPrelude'],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset('assets/stopwatch.png'),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          stats['exerciseRemaining'].toString(),
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ), 
                
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
