import 'package:bloc_exercise/blocs/workout_cubit.dart';
import 'package:bloc_exercise/blocs/workouts_cubit.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:bloc_exercise/screens/home_page.dart';
import 'package:bloc_exercise/screens/workout_in_progress.dart';
import 'package:bloc_exercise/states/workout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'screens/edit_workout_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  runApp(const WorkoutTime());
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My workout',
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.grey))),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutsCubit>(
            create: (context) {
              WorkoutsCubit workoutsCubit = WorkoutsCubit();

              if (workoutsCubit.state.isEmpty) {
                workoutsCubit.getWorkouts();
              } else {}
              return workoutsCubit;
            },
          ),
          BlocProvider<WorkoutCubit>(
            create: (context) {
              return WorkoutCubit();
            },
          )
        ],
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
            builder: (context, workoutstate) {
          if (workoutstate is WorkoutInitial) {
            return const HomePage();
          } else {
            if (workoutstate is WorkoutEditting) {
              return const EditWorkoutScreen();
            }
            return const WorkoutInProgressScreen();
          }
        }),
      ),
    );
  }
}
