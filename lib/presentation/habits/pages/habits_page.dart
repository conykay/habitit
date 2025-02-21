import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/data/habits/repository/habits_repository_impl.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/habits/bloc/selected_frequency_cubit.dart';
import 'package:habitit/presentation/habits/pages/habit_details_page.dart';
import 'package:intl/intl.dart';

import '../widget/new_habit_modal.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HabitStateCubit>()..getHabits(),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width >= 600 ? 400 : null,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: BlocBuilder<HabitStateCubit, HabitState>(
                builder: (context, state) {
                  if (state is HabitLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is HabitLoaded) {
                    if (state.habits.isEmpty) {
                      return Center(
                        child: Text('No habits found'),
                      );
                    }
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          var habit = state.habits[index];
                          return GestureDetector(
                            onTap: () {
                              AppNavigator.push(
                                  context,
                                  HabitDetailsPage(
                                    habit: habit,
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    habit.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(habit.description ?? ''),
                                            Text(
                                              habit.frequency.name
                                                  .toUpperCase(),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text.rich(TextSpan(
                                                text: habit
                                                    .completedDates!.length
                                                    .toString(),
                                                children: [
                                                  TextSpan(
                                                      text: ' days Completed')
                                                ])),
                                            Text.rich(TextSpan(
                                                text: 'Since: ',
                                                children: [
                                                  TextSpan(
                                                      text: DateFormat.yMd()
                                                          .format(habit
                                                              .startDate
                                                              .toDate()))
                                                ])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: state.habits.length);
                  }
                  if (state is HabitError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  return Center(
                    child: Text('Your habits go here'),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, right: 20),
                child: Builder(builder: (context) {
                  return FloatingActionButton(
                    onPressed: () async {
                      final repo = context.read<HabitsRepositoryImpl>();
                      final selectedCubit =
                          context.read<SelectedFrequencyCubit>();
                      final habitstate = context.read<HabitStateCubit>();
                      final result = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return RepositoryProvider.value(
                            value: repo,
                            child: BlocProvider.value(
                              value: habitstate,
                              child: BlocProvider.value(
                                  value: selectedCubit,
                                  child: NewHabitCustomModal()),
                            ),
                          );
                        },
                      );
                      if (result == true) {
                        if (context.mounted) {
                          context.read<HabitStateCubit>().getHabits();
                        }
                      }
                    },
                    child: FaIcon(FontAwesomeIcons.plus),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
