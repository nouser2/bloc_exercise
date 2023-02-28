import 'package:bloc_exercise/blocs/workout_cubit.dart';
import 'package:bloc_exercise/blocs/workouts_cubit.dart';
import 'package:bloc_exercise/helpers/helpers.dart';
import 'package:bloc_exercise/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class EditExerciseScreen extends StatefulWidget {
  const EditExerciseScreen({
    super.key,
    this.workout,
    this.exIndex,
    required this.index,
  });
  final Workout? workout;
  final int? exIndex;
  final int index;

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? _title;

  @override
  void initState() {
    _title = TextEditingController(
        text: widget.workout!.exercises[widget.exIndex!].title);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: InkWell(
              onLongPress: () => showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController(
                      text: widget.workout!.exercises[widget.exIndex!].prelude!
                          .toString());
                  return AlertDialog(
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Prelude (sec)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            Navigator.pop(context);
                            setState(() {
                              widget.workout!.exercises[widget.exIndex!] =
                                  widget.workout!.exercises[widget.exIndex!]
                                      .copyWith(
                                prelude: int.parse(controller.text),
                              );
                              BlocProvider.of<WorkoutsCubit>(context)
                                  .saveWorkout(
                                widget.workout!,
                                widget.index,
                              );
                            });
                          }
                        },
                        child: const Text('save'),
                      ),
                    ],
                  );
                },
              ),
              child: NumberPicker(
                itemHeight: 30,
                value: widget.workout!.exercises[widget.exIndex!].prelude!,
                minValue: 0,
                maxValue: 3599,
                textMapper: (startVal) =>
                    formatTime(int.parse(startVal), false),
                onChanged: (value) {
                  setState(() {
                    widget.workout!.exercises[widget.exIndex!] =
                        widget.workout!.exercises[widget.exIndex!].copyWith(
                      prelude: value,
                    );
                    BlocProvider.of<WorkoutsCubit>(context).saveWorkout(
                      widget.workout!,
                      widget.index,
                    );
                  });
                },
              ),
            )),
            Expanded(
                flex: 3,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _title,
                  onChanged: (value) => setState(() {
                    widget.workout!.exercises[widget.exIndex!] =
                        widget.workout!.exercises[widget.exIndex!].copyWith(
                      title: value,
                    );
                    BlocProvider.of<WorkoutsCubit>(context).saveWorkout(
                      widget.workout!,
                      widget.index,
                    );
                  }),
                )),
            Expanded(
                child: InkWell(
              onLongPress: () => showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController(
                      text: widget.workout!.exercises[widget.exIndex!].duration!
                          .toString());
                  return AlertDialog(
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Duration (sec)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            Navigator.pop(context);
                            setState(() {
                              widget.workout!.exercises[widget.exIndex!] =
                                  widget.workout!.exercises[widget.exIndex!]
                                      .copyWith(
                                duration: int.parse(controller.text),
                              );
                              BlocProvider.of<WorkoutsCubit>(context)
                                  .saveWorkout(
                                widget.workout!,
                                widget.index,
                              );
                            });
                          }
                        },
                        child: const Text('save'),
                      ),
                    ],
                  );
                },
              ),
              child: NumberPicker(
                itemHeight: 30,
                value: widget.workout!.exercises[widget.exIndex!].duration!,
                minValue: 0,
                maxValue: 3599,
                textMapper: (startVal) =>
                    formatTime(int.parse(startVal), false),
                onChanged: (value) {
                  setState(() {
                    widget.workout!.exercises[widget.exIndex!] =
                        widget.workout!.exercises[widget.exIndex!].copyWith(
                      duration: value,
                    );
                    BlocProvider.of<WorkoutsCubit>(context).saveWorkout(
                      widget.workout!,
                      widget.index,
                    );
                  });
                },
              ),
            )),
          ],
        )
      ],
    );
  }
}
