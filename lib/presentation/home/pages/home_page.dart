import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/data/habits/repository/habits_repository_impl.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_cubit.dart';
import 'package:habitit/presentation/home/bloc/mark_habit_complete_sate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<HabitStateCubit>()..getHabits(),
        ),
        BlocProvider(
          create: (context) =>
              MarkHabitCompleteCubit(context.read<HabitsRepositoryImpl>()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greetingTitle(),
            SizedBox(height: 15),
            _homeCalendarView(context),
            SizedBox(height: 15),
            _taskSectionTitle(),
            SizedBox(height: 15),
            Expanded(child: BlocBuilder<HabitStateCubit, HabitState>(
                builder: (context, state) {
              if (state is HabitLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is HabitLoaded) {
                return Column(
                  children: [
                    TodayHabitsWidget(habits: state.habits),
                  ],
                );
              }
              if (state is HabitError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return Container();
            }))
          ],
        ),
      ),
    );
  }

  Row _taskSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Todays Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text('remaining'),
      ],
    );
  }

  TableCalendar<dynamic> _homeCalendarView(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 7)),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      rowHeight: 70,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Column _greetingTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_greeting()[0]},',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(
          _greeting()[1],
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  List<String> _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return ['Good Morning', 'Ready to tackle the day ?'];
    }
    if (hour < 17) {
      return ['Afternoon', 'Dont forget to reward yourself'];
    }

    return ['Evening', 'There\'s still time'];
  }
}

class TodayHabitsWidget extends StatelessWidget {
  final List<HabitEnity> habits;
  const TodayHabitsWidget({
    super.key,
    required this.habits,
  });

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.year);

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
                          context.read<HabitStateCubit>().getHabits();
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
