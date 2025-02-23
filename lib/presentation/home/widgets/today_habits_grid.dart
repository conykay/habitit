import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_sate.dart';

import '../../../domain/habits/usecases/get_all_habits_usecase.dart';
import '../../../domain/rewards/repository/rewards_repository.dart';
import '../../../domain/rewards/usecases/add_user_xp_usecase.dart';
import '../../profile/bloc/user_rewards_cubit.dart';

class TodayHabitsWidget extends StatelessWidget {
  final List<HabitEnity> habits;
  const TodayHabitsWidget({
    super.key,
    required this.habits,
  });

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<HabitEnity> get incompleteHabits {
    final today = _normalize(DateTime.now());
    return habits.where((habit) {
      final normalizedDates =
          habit.completedDates!.map((d) => _normalize(d)).toList();
      return !normalizedDates.contains(today);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayHabits = incompleteHabits;
    return GridView.builder(
        itemCount: displayHabits.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          var color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
          var habit = displayHabits[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<MarkHabitCompleteCubit, MarkHabitCompleteSate>(
                    builder: (context, state) {
                  return Builder(builder: (context) {
                    return TextButton(
                        onPressed: () async {
                          var editedHabit = HabitEnity(
                              id: habit.id,
                              name: habit.name,
                              frequency: habit.frequency,
                              startDate: habit.startDate,
                              synced: habit.synced,
                              description: habit.description,
                              completedDates: [
                                DateTime.now(),
                                ...habit.completedDates!
                              ]);
                          context
                              .read<MarkHabitCompleteCubit>()
                              .markComplete(habit: editedHabit);
                          context.read<UserRewardsCubit>().updateUserRewards(
                              usecase: AddUserXpUsecase(
                                  repository:
                                      context.read<RewardsRepository>()),
                              xp: 20);
                          context.read<HabitStateCubit>().getHabits(
                              usecase: GetAllHabitsUsecase(
                                  repository: context.read<HabitRepository>()));
                        },
                        style: TextButton.styleFrom(
                          padding: null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Finish'),
                            SizedBox(width: 5),
                            FaIcon(FontAwesomeIcons.circleCheck)
                          ],
                        ));
                  });
                }),
                SizedBox(height: 5),
                Text(
                  displayHabits[index].name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(displayHabits[index].description ?? 'Pending'),
              ],
            ),
          );
        });
  }
}
