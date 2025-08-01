// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/common/rewards/reward_badges.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/theme/bloc/theme_cubit.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';
import 'package:habitit/presentation/profile/widgets/badge.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({
    super.key,
  });

  UserRewardEntity? userReward;

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
          switch (state) {
            case UnAuthenticated():
              AppNavigator.pushAndRemove(context, SignInPage());
              break;
            default:
              break;
          }
        },
        child: LayoutBuilder(builder: (context, constrains) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: BlocBuilder<UserRewardsCubit, UserRewardsState>(
                builder: (context, state) {
                  switch (state) {
                    case UserRewardsError():
                      return Center(
                        child: Text(state.error.toString()),
                      );
                    case UserRewardsLoaded():
                      userReward = state.rewards;
                      break;
                    default:
                      break;
                  }

                  var isLoading = state is UserRewardsLoading;
                  if (userReward != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: isLoading
                                ? LinearProgressIndicator()
                                : SizedBox(),
                          ),
                          _pointsDisplay(context, userReward!),
                          SizedBox(height: 20),
                          _achievementsList(
                              badgesEarned: userReward!.earnedBadges),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preferences',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Brightness',
                                        style: TextStyle(fontSize: 20)),
                                    BlocBuilder<ThemeCubit, ThemeState>(
                                      builder: (context, state) {
                                        return Switch(
                                            value: state.themeMode ==
                                                ThemeMode.dark,
                                            onChanged: (_) async => context
                                                .read<ThemeCubit>()
                                                .switchTheme());
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              BlocBuilder<UserRewardsCubit, UserRewardsState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (state is UserRewardsLoaded) {
                                        context.read<AuthStateCubit>().logout();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Log Out',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red)),
                                          FaIcon(FontAwesomeIcons.doorOpen,
                                              color: Colors.red)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Column _achievementsList({required List<String> badgesEarned}) {
    var userBadge =
        badges.where((badge) => badgesEarned.contains(badge.id)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: badgesEarned.isEmpty
              ? Center(
                  child: Text(
                      'You havent earned any badges,create your first habit to start.'),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AchievementBadge(
                      colors: userBadge[index].colors,
                      icon: userBadge[index].icon,
                      name: userBadge[index].name,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: userBadge.length),
        ),
      ],
    );
  }

  Container _pointsDisplay(BuildContext context, UserRewardEntity rewards) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Points',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                Text.rich(
                    TextSpan(text: rewards.xp.toString(), children: [
                      TextSpan(text: 'xp', style: TextStyle(fontSize: 20))
                    ]),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.primary))
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
                        color: Theme.of(context).colorScheme.primary)),
                Text(rewards.level.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.primary))
              ],
            )),
          ],
        ));
  }
}
