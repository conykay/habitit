// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/habit/analytics_calculator.dart';
import 'package:habitit/data/habits/models/habit_frequency.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../core/network/network_info.dart';
import '../../../data/habits/repository/habits_repository_impl.dart';
import '../../../data/habits/source/habits_firebase_service.dart';
import '../../../data/habits/source/habits_hive_service.dart';
import '../bloc/selected_frequency_cubit.dart';
import '../widget/details_app_bar.dart';
import '../widget/habit_calendar_widget.dart';

class HabitDetailsPage extends StatelessWidget {
  final HabitEnity habit;
  HabitDetailsPage({
    super.key,
    required this.habit,
  });

  final hiveService = HabitsHiveServiceImpl();
  final firebaseService = HabitsFirebaseServiceImpl();
  final networkInfo = NetworkInfoImpl(
      internetConnectionChecker: InternetConnectionChecker.instance);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<HabitRepository>(
      create: (context) => HabitsRepositoryImpl(
          hiveService: hiveService,
          firebaseService: firebaseService,
          networkInfo: networkInfo),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SelectedFrequencyCubit()),
        ],
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomAppBar(habit: habit)),
          body: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
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
                      _completedRepeat(),
                      SizedBox(height: 20),
                      _streakBox(context),
                      SizedBox(height: 20),
                      HabitCalendarWidget(habit: habit)
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Row _completedRepeat() {
    return Row(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  habit.frequency == HabitFrequency.daily ? 'Daily' : 'Weekly',
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
    );
  }

  Container _streakBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
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
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_streak(completedDays: habit.completedDates!)} days',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
    );
  }

  String _streak({required List<DateTime> completedDays}) {
    var streak = calculateLongestStreak(completedDays);
    return streak.toString();
  }
}
