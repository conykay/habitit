// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/common/rewards/reward_badges.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

import '../../../core/network/network_info.dart';
import '../../../service_locator.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final _firebaseRewardService = sl.get<RewardsFirebaseService>();
  final _networkInfo = sl.get<NetworkInfoService>();

  @override
  Future<Either> updateUserRewards({required int xpAmount}) async {
    var isOnline = await _networkInfo.hasConnection;
    final hiveRewardService = await sl.getAsync<RewardsHiveService>();
    try {
      //get rewards from local Db
      UserRewardEntity userRewardUpdate =
          await hiveRewardService.getUserRewards();
      // update local db with new reward data
      UserRewardEntity updatedReward =
          await _updateReward(reward: userRewardUpdate, xpGained: xpAmount);
      await hiveRewardService.updateUserRewards(rewardModel: updatedReward);
      //update remote db with new reward data
      if (isOnline) {
        UserRewardEntity userLocalReward =
            await hiveRewardService.getUserRewards();
        //Update remote rewards with local rewards
        try {
          if (!userLocalReward.synced) {
            await _firebaseRewardService.updateUserRewards(
                rewardModel: userLocalReward.toModel());
          }
        } catch (e) {
          print('Failed to update remote rewards: ${e.toString()}');
        }
      }
      return Right('Updated Your Rewards');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<Either> getUserRewards() async* {
    var isOnline = await _networkInfo.hasConnection;
    final hiveRewardService = await sl.getAsync<RewardsHiveService>();

    try {
      //Get User Reward from local Db
      UserRewardEntity localRewards = await hiveRewardService.getUserRewards();
      yield Right(localRewards);
      //Get User Reward from remote Db
      if (isOnline) {
        try {
          //Get User Reward from remote Db
          UserRewardsNetworkModel remoteRewards =
              await _firebaseRewardService.getUserRewards();
          //compare data
          if (localRewards.xp > remoteRewards.xp) {
            await _firebaseRewardService.updateUserRewards(
                rewardModel: localRewards.toModel());
            //mark local data as synced
            await hiveRewardService.updateUserRewards(
                rewardModel: localRewards.copyWith(synced: true));
          } else if (localRewards.xp < remoteRewards.xp) {
            //Update local rewards with remote rewards
            await hiveRewardService.updateUserRewards(
                rewardModel: remoteRewards.toEntity().copyWith(synced: true));
          }
          //Get User Reward from local Db
          localRewards = await hiveRewardService.getUserRewards();

          yield Right(localRewards);
        } catch (e) {
          print('Failed to retrieve rewards from Remote DB: ${e.toString()}');
        }
      }
    } catch (e) {
      yield Left(e.toString());
    }
  }

  //Update User Reward and Send Notification
  Future<UserRewardEntity> _updateReward({
    required UserRewardEntity reward,
    required int xpGained,
  }) async {
    //create new instance and add xp to current user xp
    UserRewardEntity updatedReward =
        reward.copyWith(xp: reward.xp + xpGained, synced: false);
    //give first badge if user has 10 xp for the first time
    if (updatedReward.xp >= 10) {
      updatedReward = await _awardBadgeIfEligible(
        reward: updatedReward,
        badgeId: 'first_habit',
      );
    }
    //level increase every 100xp. Update level
    int newLevel = (updatedReward.xp ~/ 100) + 1;
    if (newLevel > updatedReward.level) {
      updatedReward = updatedReward.copyWith(level: newLevel);
    }
    //Award level_up badge for reaching level 2
    if (updatedReward.level == 2) {
      updatedReward = await _awardBadgeIfEligible(
        reward: updatedReward,
        badgeId: 'level_up',
      );
    }
    //Award level 10 badge for reaching level 10 higher
    if (reward.level >= 10) {
      updatedReward = await _awardBadgeIfEligible(
        reward: updatedReward,
        badgeId: 'level_ten',
      );
    }

    return updatedReward;
  }

  Future<UserRewardEntity> _awardBadgeIfEligible({
    required UserRewardEntity reward,
    required String badgeId,
  }) async {
    //check if user already earned badge
    if (!reward.earnedBadges.contains(badgeId)) {
      //add badge to earned badges
      final List<String> newEarnedBadges = List.from(reward.earnedBadges)
        ..add(badgeId);
      //create new instance with new earned badges
      UserRewardEntity rewardWithNewBadge =
          reward.copyWith(earnedBadges: newEarnedBadges);
      //send notification about new badge
      final badgeData = badges.firstWhere((b) => b.id == badgeId);
      await _firebaseRewardService.sendNewBadgeNotification(badge: badgeData);
      return rewardWithNewBadge;
    }
    return reward;
  }
}
