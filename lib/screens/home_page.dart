import 'package:bloc_exercise/blocs/workout_cubit.dart';
import 'package:bloc_exercise/blocs/workouts_cubit.dart';
import 'package:bloc_exercise/helpers/helpers.dart';
import 'package:bloc_exercise/main.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Time'),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutsCubit, List<Workout>>(
          builder: (context, workouts) {
            // for only one panel open in a expension list
            return ExpansionPanelList.radio(
              children: workouts
                  .map(
                    (workoutelement) => ExpansionPanelRadio(
                      value: workoutelement,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: VisualDensity.maximumDensity),
                          leading: IconButton(
                            onPressed: () =>
                                BlocProvider.of<WorkoutCubit>(context)
                                    .editWorkout(workoutelement,
                                        workouts.indexOf(workoutelement)),
                            icon: const Icon(Icons.edit),
                          ),
                          trailing:
                              Text(formatTime(workoutelement.getTotal(), true)),
                          title: Text(workoutelement.title!),
                          onTap: () => !isExpanded
                              ? BlocProvider.of<WorkoutCubit>(context)
                                  .startWorkout(workoutelement)
                              : null,
                        );
                      },
                      body: ListView.builder(
                        shrinkWrap: true,
                        itemCount: workoutelement.exercises.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            visualDensity: const VisualDensity(
                              horizontal: 0,
                              vertical: VisualDensity.maximumDensity,
                            ),
                            leading: Text(formatTime(
                                workoutelement.exercises[index].prelude!,
                                true)),
                            trailing: Text(formatTime(
                                workoutelement.exercises[index].duration!,
                                true)),
                            title: Text(workoutelement.exercises[index].title!),
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
