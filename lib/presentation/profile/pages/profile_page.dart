// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';

import '../widgets/achievements_view.dart';
import '../widgets/experience_points_view.dart';
import '../widgets/preferences_view.dart';

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
      child: LayoutBuilder(builder: (context, constrains) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child:
                      BlocBuilder<UserRewardsCubit, UserRewardsState>(
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: isLoading
                                ? LinearProgressIndicator()
                                : SizedBox(),
                          ),
                          ExperiencePointsView(rewards: userReward!),
                          SizedBox(height: 20),
                          AchievementsView(
                              badgesEarned: userReward!.earnedBadges),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })),
                  Expanded(child: PreferencesView())
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
