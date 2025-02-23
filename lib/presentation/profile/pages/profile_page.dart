// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/common/rewards/reward_badges.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';
import 'package:habitit/presentation/profile/widgets/badge.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<UserRewardsCubit>()..getUserRewards(),
        ),
        BlocProvider.value(
          value: context.read<HabitStateCubit>()..getHabits(),
        ),
      ],
      child: BlocListener<AuthStateCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushAndRemove(context, SigninPage());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pointsDisplay(context),
              SizedBox(height: 20),
              _acheivementsList(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preferences',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brightness', style: TextStyle(fontSize: 20)),
                        Switch(value: true, onChanged: (value) {})
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Log Out',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.red)),
                          FaIcon(FontAwesomeIcons.doorOpen, color: Colors.red)
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column _acheivementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: BlocBuilder<UserRewardsCubit, UserRewardsState>(
            builder: (context, state) {
              if (state is UserRewardsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UserRewardsError) {
                return Center(
                  child: Text(state.error.toString()),
                );
              }
              if (state is UserRewardsLoaded) {
                if (state.rewards.earnedBadges.isEmpty) {
                  return Center(
                    child: Text(
                        'You havent earned any badges,create your first habit to start.'),
                  );
                }
                return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return AchievementBadge(
                        colors: badges[index].colors,
                        icon: badges[index].icon,
                        name: badges[index].name,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                    itemCount: badges.length);
              }

              return Container();
            },
          ),
        ),
      ],
    );
  }

  Container _pointsDisplay(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      child: BlocBuilder<UserRewardsCubit, UserRewardsState>(
        builder: (context, state) {
          if (state is UserRewardsLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is UserRewardsError) {
            return Center(
              child: Text(state.error.toString()),
            );
          }
          if (state is UserRewardsLoaded) {
            return Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Points',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    Text.rich(
                        TextSpan(text: state.rewards.xp.toString(), children: [
                          TextSpan(text: 'xp', style: TextStyle(fontSize: 20))
                        ]),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            color: Theme.of(context).primaryColor))
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Level',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    Text(state.rewards.level.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                            color: Theme.of(context).primaryColor))
                  ],
                )),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
