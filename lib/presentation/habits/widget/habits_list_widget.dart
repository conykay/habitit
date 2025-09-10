import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/navigation/app_router.dart';
import '../../../domain/habits/entities/habit_entity.dart';

class HabitsListView extends StatelessWidget {
  final List<HabitEntity> habits;

  const HabitsListView({
    super.key,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        var habit = habits[index];
        return Card(
          child: ListTile(
            title: Text(
              habit.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(habit.description!),
            dense: false,
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FaIcon(FontAwesomeIcons.arrowRight, size: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(
                        text: habit.completedDates!.length.toString(),
                        children: [TextSpan(text: 'd done')])),
                    Text.rich(TextSpan(text: 'Since: ', children: [
                      TextSpan(text: DateFormat.yMd().format(habit.startDate))
                    ])),
                  ],
                )
              ],
            ),
            onTap: () {
              context.pushNamed(AppRoutes.habitDetails, extra: habit);
            },
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(),
      itemCount: habits.length,
    );
  }
}
