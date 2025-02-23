// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../bloc/selected_frequency_cubit.dart';
import '../widget/edit_habit_modal.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.habit,
  });

  final HabitEnity habit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Details'),
      actions: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () async {
              final repo = context.read<HabitRepository>();
              final selectedCubit = context.read<SelectedFrequencyCubit>();
              final result = await showModalBottomSheet(
                context: context,
                builder: (context) {
                  return RepositoryProvider.value(
                    value: repo,
                    child: BlocProvider.value(
                        value: selectedCubit,
                        child: EditHabitWidget(
                          habit: habit,
                        )),
                  );
                },
              );
              if (result == true) {
                if (context.mounted) {
                  var snack = SnackBar(
                    content: Text(
                        'Content will be updated the next time you open this page'),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }
              }
            },
            icon: FaIcon(FontAwesomeIcons.penClip),
            color: Theme.of(context).colorScheme.secondary,
          );
        }),
        Builder(builder: (context) {
          return IconButton(
            onPressed: () async {
              final repo = context.read<HabitRepository>();

              var value = await showDialog(
                  context: context,
                  builder: (context) => RepositoryProvider.value(
                        value: repo,
                        child: AlertDialog(
                          title: Text('Delete Habit'),
                          content: Text(
                              'Are you sure you want to delete this habit.'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text('Dissmiss')),
                            SizedBox(height: 10),
                            Builder(builder: (context) {
                              return ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<HabitRepository>()
                                        .deleteHabit(habit: habit)
                                        .then((_) {
                                      if (context.mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    });
                                  },
                                  child: Text('Delete'));
                            }),
                          ],
                        ),
                      ));

              if (value && context.mounted) {
                Navigator.pop(context, value);
              }
            },
            icon: FaIcon(
              FontAwesomeIcons.trashCan,
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }),
      ],
    );
  }
}
