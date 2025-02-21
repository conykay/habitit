import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/data/habits/models/habit_frequency.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/usecases/edit_habit_usecase.dart';

import '../../../common/button/bloc/button_state.dart';
import '../../../common/button/bloc/button_state_cubit.dart';
import '../../../common/button/widget/reactive_elevated_button.dart';
import '../../../data/habits/repository/habits_repository_impl.dart';
import '../bloc/selected_frequency_cubit.dart';

class EditHabitWidget extends StatelessWidget {
  EditHabitWidget({
    super.key,
    required this.habit,
  });

  final HabitEnity habit;

  final _formKey = GlobalKey<FormState>();
  final _habitNameController = TextEditingController();
  final _habitDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _habitNameController.text = habit.name;
    _habitDescriptionController.text = habit.description ?? '';
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state.state == Buttonstate.failed) {
            var snack = SnackBar(
              content: Text(state.error.toString()),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Edit Habit',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Change the details but not your mind',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _habitNameController,
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Name: e.g. Drink water',
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _habitDescriptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        _habitDescriptionController.text = 'No description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Description: e.g. Drink 8 glasses of water',
                    ),
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<SelectedFrequencyCubit, HabitFrequency>(
                    builder: (context, state) {
                      context
                          .read<SelectedFrequencyCubit>()
                          .setInitial(initState: habit.frequency);
                      return Row(
                        children: [
                          Expanded(
                              child: ListTile(
                            title: Text('Daily'),
                            leading: Radio(
                                value: HabitFrequency.daily,
                                groupValue: state,
                                onChanged: (value) {
                                  context
                                      .read<SelectedFrequencyCubit>()
                                      .selectFrequency(value!);
                                }),
                          )),
                          Expanded(
                              child: ListTile(
                            title: Text('Weekly'),
                            leading: Radio(
                                value: HabitFrequency.weekly,
                                groupValue: state,
                                onChanged: (value) {
                                  context
                                      .read<SelectedFrequencyCubit>()
                                      .selectFrequency(value!);
                                }),
                          )),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Builder(builder: (context) {
                    return ReactiveElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await context
                                .read<ButtonStateCubit>()
                                .call(
                                    usecase: EditHabitUsecase(
                                        repository: context
                                            .read<HabitsRepositoryImpl>()),
                                    params: HabitEnity(
                                        id: habit.id,
                                        name: _habitNameController.text,
                                        description:
                                            _habitDescriptionController.text,
                                        frequency: context
                                            .read<SelectedFrequencyCubit>()
                                            .state,
                                        startDate: habit.startDate,
                                        synced: false))
                                .then((_) {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            });
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context, false);
                            }
                          }
                        }
                      },
                      title: 'Make Changes',
                    );
                  })
                ],
              )),
        ),
      ),
    );
  }
}
