import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';
import 'package:habitit/domain/rewards/usecases/add_user_xp_usecase.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../common/button/bloc/button_state.dart';
import '../../../common/button/bloc/button_state_cubit.dart';
import '../../../common/button/widget/reactive_elevated_button.dart';
import '../../../data/habits/models/habit_frequency.dart';
import '../../../data/habits/models/habit_model.dart';
import '../../../domain/habits/usecases/add_habit_usecase.dart';
import '../bloc/selected_frequency_cubit.dart';

class NewHabitCustomModal extends StatefulWidget {
  const NewHabitCustomModal({
    super.key,
  });

  @override
  State<NewHabitCustomModal> createState() => _NewHabitCustomModalState();
}

class _NewHabitCustomModalState extends State<NewHabitCustomModal> {
  final _habitNameController = TextEditingController();

  final _habitDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height * 0.7,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Habit',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Comitment to change is only the first step',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _habitNameController,
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
                                      usecase: AddHabitUsecase(
                                          habitRepository:
                                              context.read<HabitRepository>()),
                                      params: HabitModel(
                                          id: Uuid().v4(),
                                          name: _habitNameController.text,
                                          description:
                                              _habitDescriptionController.text,
                                          frequency: context
                                              .read<SelectedFrequencyCubit>()
                                              .state,
                                          startDate: DateTime.now()))
                                  .then((_) async {
                                if (context.mounted) {
                                  context
                                      .read<UserRewardsCubit>()
                                      .updateUserRewards(
                                          usecase: AddUserXpUsecase(
                                              repository: context
                                                  .read<RewardsRepository>()),
                                          xp: 10);
                                }
                              });
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context, false);
                              }
                            }
                          }
                        },
                        title: 'Start',
                      );
                    })
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
