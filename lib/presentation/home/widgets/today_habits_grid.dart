import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';

import '../../../domain/habits/entities/habit_entity.dart';
import '../../profile/bloc/user_rewards_cubit.dart';

class TodayHabitsView extends StatelessWidget {
  final List<HabitEntity> habits;

  const TodayHabitsView({
    super.key,
    required this.habits,
  });

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<HabitEntity> get incompleteHabits {
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
    if (displayHabits.isEmpty) {
      return const NothingToDisplayView();
    }
    return HabitsGridView(displayHabits: displayHabits);
  }
}

class HabitsGridView extends StatelessWidget {
  const HabitsGridView({
    super.key,
    required this.displayHabits,
  });

  final List<HabitEntity> displayHabits;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: displayHabits.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kIsWeb ? 3 : 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1),
        itemBuilder: (context, index) {
          var color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
          var HabitEntity(
            :id,
            :name,
            :frequency,
            :startDate,
            :synced,
            :description,
            :completedDates
          ) = displayHabits[index];
          var editedHabit = HabitEntity(
            id: id,
            name: name,
            frequency: frequency,
            startDate: startDate,
            synced: synced,
            description: description,
            completedDates: [DateTime.now(), ...completedDates!],
          );

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () {
                      context
                          .read<MarkHabitCompleteCubit>()
                          .markComplete(habit: editedHabit);
                      context
                          .read<UserRewardsCubit>()
                          .updateUserRewards(xp: 20);
                      context.read<HabitStateCubit>().getHabits();
                    },
                    style: TextButton.styleFrom(padding: null),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Finish'),
                        SizedBox(width: 5),
                        FaIcon(FontAwesomeIcons.circleCheck)
                      ],
                    )),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(description ?? 'Pending'),
              ],
            ),
          );
        });
  }
}

class NothingToDisplayView extends StatelessWidget {
  const NothingToDisplayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.flagCheckered,
          color: Theme.of(context).colorScheme.secondary,
          size: 50,
        ),
        const SizedBox(height: 20),
        const Text(
          'You seem to be done for the day. Do something fun',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
