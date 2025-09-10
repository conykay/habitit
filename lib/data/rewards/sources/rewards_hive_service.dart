import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:hive_flutter/adapters.dart';

abstract class RewardsHiveService {
  Future<UserRewardEntity> getUserRewards();

  Future<void> updateUserRewards({required UserRewardEntity rewardModel});
}

class RewardsHiveServiceImpl implements RewardsHiveService {
  @override
  Future<UserRewardEntity> getUserRewards() async {
    final rewardBox = await Hive.openBox<UserRewardEntity>('Rewards');
    try {
      if (rewardBox.values.isNotEmpty) {
        return rewardBox.values.first;
      } else {
        return UserRewardEntity();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRewards(
      {required UserRewardEntity rewardModel}) async {
    final rewardBox = await Hive.openBox<UserRewardEntity>('Rewards');
    try {
      await rewardBox.put(0, rewardModel);
    } catch (e) {
      rethrow;
    }
  }
}
