// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/habit/streaks_calculator.dart';
import 'package:habitit/data/habits/models/habit_frequency.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/network/network_info.dart';
import '../../../data/habits/repository/habits_repository_impl.dart';
import '../../../data/habits/source/firebase_service.dart';
import '../../../data/habits/source/hive_service.dart';
import '../bloc/selected_frequency_cubit.dart';
import '../widget/edit_habit_modal.dart';
import '../widget/habit_calendar_widget.dart';

class HabitDetailsPage extends StatelessWidget {
  final HabitEnity habit;
  HabitDetailsPage({
    super.key,
    required this.habit,
  });

  final hiveService = HiveServiceImpl();
  final firebaseService = FirebaseServiceImpl();
  final networkInfo = NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.instance);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HabitsRepositoryImpl(
          hiveService: hiveService,
          firebaseService: firebaseService,
          networkInfo: networkInfo),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SelectedFrequencyCubit()),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text('Details'),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () async {
                    final repo = context.read<HabitsRepositoryImpl>();
                    final selectedCubit =
                        context.read<SelectedFrequencyCubit>();
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
                    final repo = context.read<HabitsRepositoryImpl>();

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
                                              .read<HabitsRepositoryImpl>()
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
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    habit.description ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.repeat,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Repeat',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                habit.frequency == HabitFrequency.daily
                                    ? 'Daily'
                                    : 'Weekly',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.flagCheckered,
                            size: 40,
                            color: Colors.deepOrange,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Completed',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${habit.completedDates!.length} Days',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepOrange,
                                ),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Streak',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_streak(completedDays: habit.completedDates!)} days',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Your Longest Streak',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                            child: FaIcon(
                          FontAwesomeIcons.boltLightning,
                          size: 80,
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  HabitCalendarWidget(habit: habit)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _streak({required List<DateTime> completedDays}) {
    var streak = calculateLongestStreak(completedDays);
    return streak.toString();
  }
}
