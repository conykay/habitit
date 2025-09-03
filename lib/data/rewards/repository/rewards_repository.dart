// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/common/rewards/reward_badges.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

import '../../../core/network/network_info.dart';
import '../../../service_locator.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  RewardsRepositoryImpl();

  @override
  Future<Either> updateUserRewards({required int xpAmount}) async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    late UserRewardsModel userRewardsModel;
    try {
      if (isOnline) {
        userRewardsModel =
            await sl.get<RewardsFirebaseService>().getUserRewards();
        var editedReward = await _updateReward(userRewardsModel, xpAmount);
        await sl
            .get<RewardsFirebaseService>()
            .updateUserRewards(rewardModel: editedReward)
            .then((_) async => await sl
                .get<RewardsHiveService>()
                .updateUserRewards(rewardModel: editedReward));
      } else {
        userRewardsModel = await sl.get<RewardsHiveService>().getUserRewards();
        var editedReward = await _updateReward(userRewardsModel, xpAmount);
        editedReward.synced = false;
        await sl
            .get<RewardsHiveService>()
            .updateUserRewards(rewardModel: editedReward);
      }
      return Right('Updated Your Rewards');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getUserRewards() async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    late UserRewardsModel userReward;
    try {
      if (isOnline) {
        var localReward = await sl.get<RewardsHiveService>().getUserRewards();
        var remoteReward =
            await sl.get<RewardsFirebaseService>().getUserRewards();
        if (!localReward.synced || localReward != remoteReward) {
          await sl
              .get<RewardsHiveService>()
              .updateUserRewards(rewardModel: remoteReward);
        }
        userReward = await sl.get<RewardsHiveService>().getUserRewards();
      } else {
        userReward = await sl.get<RewardsHiveService>().getUserRewards();
      }
      return Right(userReward.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<UserRewardsModel> _updateReward(
      UserRewardsModel userRewardsModel, int xpAmmount) async {
    userRewardsModel.xp += xpAmmount;
    if (xpAmmount >= 10) {
      if (!userRewardsModel.earnedBadges.contains('first_habit')) {
        userRewardsModel.earnedBadges.add('first_habit');
        var badge = badges.where((badge) => badge.id == 'first_habit').first;
        await sl
            .get<RewardsFirebaseService>()
            .sendNewBadgeNotification(badge: badge);
      }
    }
    int newLevel = (userRewardsModel.xp ~/ 100) + 1;
    if (newLevel > userRewardsModel.level) {
      userRewardsModel.level = newLevel;
    }
    if (userRewardsModel.level == 2) {
      if (!userRewardsModel.earnedBadges.contains('level_up')) {
        userRewardsModel.earnedBadges.add('level_up');
        var badge = badges.where((badge) => badge.id == 'level_up').first;
        await sl
            .get<RewardsFirebaseService>()
            .sendNewBadgeNotification(badge: badge);
      }
    }
    if (userRewardsModel.level >= 10) {
      if (!userRewardsModel.earnedBadges.contains('level_ten')) {
        userRewardsModel.earnedBadges.add('level_ten');
        var badge = badges.where((badge) => badge.id == 'level_ten').first;
        await sl
            .get<RewardsFirebaseService>()
            .sendNewBadgeNotification(badge: badge);
      }
    }
    return userRewardsModel;
  }
}
