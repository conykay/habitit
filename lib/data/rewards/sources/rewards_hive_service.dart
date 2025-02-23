import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:hive_flutter/adapters.dart';

abstract class RewardsHiveService {
  Future<UserRewardsModel> getUserRewards();
  Future<void> updateUserRewards({required UserRewardsModel rewardModel});
}

class RewardsHiveServiceImpl implements RewardsHiveService {
  @override
  Future<UserRewardsModel> getUserRewards() async {
    final rewardBox = await Hive.openBox<UserRewardsModel>('Rewards');
    try {
      if (rewardBox.values.isNotEmpty) {
        return rewardBox.values.first;
      } else {
        return UserRewardsModel(
            xp: 0, level: 1, earnedBadges: [], synced: false);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRewards(
      {required UserRewardsModel rewardModel}) async {
    final rewardBox = await Hive.openBox<UserRewardsModel>('Rewards');
    try {
      await rewardBox.put(0, rewardModel);
    } catch (e) {
      rethrow;
    }
  }
}
