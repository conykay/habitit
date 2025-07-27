// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/usecases/get_all_habits_usecase.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/habits/pages/habit_details_page.dart';
import 'package:intl/intl.dart';

import '../../../service_locator.dart';

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
                        children: [TextSpan(text: ' days Completed')])),
                    Text.rich(TextSpan(text: 'Since: ', children: [
                      TextSpan(
                          text:
                              DateFormat.yMd().format(habit.startDate.toDate()))
                    ])),
                  ],
                )
              ],
            ),
            onTap: () async {
              var isChange = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HabitDetailsPage(
                            habit: habit,
                          )));
              if (isChange ?? false) {
                if (context.mounted) {
                  context
                      .read<HabitStateCubit>()
                      .getHabits(usecase: sl.get<GetAllHabitsUseCase>());
                }
              }
            },
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(),
      itemCount: habits.length,
    );
  }
}
