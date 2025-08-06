// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/usecases/delete_habit_usecase.dart';

import '../../../service_locator.dart';
import '../widget/edit_habit_modal.dart';

class HabitDetailsAppBar extends StatelessWidget {
  const HabitDetailsAppBar({
    super.key,
    required this.habit,
  });

  final HabitEntity habit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Details'),
      actions: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () async {
              await _editHabitPopUp(context);
            },
            icon: FaIcon(FontAwesomeIcons.penClip),
            color: Theme.of(context).colorScheme.secondary,
          );
        }),
        Builder(builder: (context) {
          return IconButton(
            onPressed: () async {
              var value = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        title: Text('Delete Habit'),
                        content:
                            Text('Are you sure you want to delete this habit.'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('No')),
                          SizedBox(height: 10),
                          Builder(builder: (context) {
                            return ElevatedButton(
                                onPressed: () {
                                  sl
                                      .get<DeleteHabitUseCase>()
                                      .call(params: habit)
                                      .then((_) {
                                    if (context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  });
                                },
                                child: Text('Yes'));
                          }),
                        ],
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

  Future<void> _editHabitPopUp(BuildContext context) async {
    late bool result;
    if (!kIsWeb) {
      result = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return EditHabitWidget(
            habit: habit,
          );
        },
      );
    } else {
      result = await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: EditHabitWidget(
              habit: habit,
            ),
          );
        },
      );
    }
    if (result == true) {
      if (context.mounted) {
        var snack = SnackBar(
          content:
              Text('Content will be updated the next time you open this page'),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      }
    }
  }
}
