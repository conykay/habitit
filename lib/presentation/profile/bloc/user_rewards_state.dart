// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';

sealed class UserRewardsState {}

class UserRewardsInitial extends UserRewardsState {}

class UserRewardsLoading extends UserRewardsState {
  final UserRewardEntity? oldRewards;
  UserRewardsLoading(this.oldRewards);
}

class UserRewardsLoaded extends UserRewardsState {
  final UserRewardEntity rewards;
  UserRewardsLoaded({
    required this.rewards,
  });
}

class UserRewardsError extends UserRewardsState {
  String? error;
  UserRewardsError({
    this.error,
  });
}
