import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';

import '../widgets/achievements_view.dart';
import '../widgets/experience_points_view.dart';
import '../widgets/preferences_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<UserRewardsCubit>().getUserRewards();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Column(
                  children: [
                    BlocBuilder<UserRewardsCubit, UserRewardsState>(
                        builder: (context, state) {
                      switch (state) {
                        case UserRewardsLoading():
                          final bool hasData =
                              context.read<UserRewardsCubit>().hasData;
                          if (hasData && state.oldRewards != null) {
                            return _buildLoadedContent(
                                rewards: state.oldRewards!, isLoading: true);
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case UserRewardsLoaded():
                          return _buildLoadedContent(rewards: state.rewards);
                        case UserRewardsError():
                          return Center(
                            child: Text(state.error.toString()),
                          );
                        default:
                          break;
                      }
                      return SizedBox.shrink();
                    }),
                    PreferencesView(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Column _buildLoadedContent(
      {required UserRewardEntity rewards, bool isLoading = false}) {
    return Column(
      children: [
        if (isLoading)
          Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: LinearProgressIndicator()),
        ExperiencePointsView(rewards: rewards),
        SizedBox(height: 20),
        AchievementsView(badgesEarned: rewards.earnedBadges),
      ],
    );
  }
}
