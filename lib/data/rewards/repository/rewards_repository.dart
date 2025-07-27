// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/common/rewards/reward_badges.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

import '../../../core/network/network_info.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsHiveService _hiveService;
  final RewardsFirebaseService _firebaseService;
  final NetworkInfoService _networkInfo;
  RewardsRepositoryImpl({
    required RewardsHiveService hiveService,
    required RewardsFirebaseService firebaseService,
    required NetworkInfoService networkInfo,
  })  : _firebaseService = firebaseService,
        _hiveService = hiveService,
        _networkInfo = networkInfo;

  @override
  Future<Either> updateUserRewards({required int xpAmmount}) async {
    var isOnline = await _networkInfo.hasConnection;
    late UserRewardsModel userRewardsModel;
    try {
      if (isOnline) {
        userRewardsModel = await _firebaseService.getUserRewards();
        var editedReward = await _updateReward(userRewardsModel, xpAmmount);
        await _firebaseService
            .updateUserRewards(rewardModel: editedReward)
            .then((_) async => await _hiveService.updateUserRewards(
                rewardModel: editedReward));
      } else {
        userRewardsModel = await _hiveService.getUserRewards();
        var editedReward = await _updateReward(userRewardsModel, xpAmmount);
        editedReward.synced = false;
        await _hiveService.updateUserRewards(rewardModel: editedReward);
      }
      return Right('Updated Your Rewards');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getUserRewards() async {
    var isOnline = await _networkInfo.hasConnection;
    late UserRewardsModel userReward;
    try {
      if (isOnline) {
        var localReward = await _hiveService.getUserRewards();
        var remoteReward = await _firebaseService.getUserRewards();
        if (!localReward.synced ||
            !localReward.isInBox ||
            localReward != remoteReward) {
          await _hiveService.updateUserRewards(rewardModel: remoteReward);
        }
        userReward = await _hiveService.getUserRewards();
      } else {
        userReward = await _hiveService.getUserRewards();
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
        await _firebaseService.sendNewBadgeNotification(badge: badge);
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
        await _firebaseService.sendNewBadgeNotification(badge: badge);
      }
    }
    if (userRewardsModel.level >= 10) {
      if (!userRewardsModel.earnedBadges.contains('level_ten')) {
        userRewardsModel.earnedBadges.add('level_ten');
        var badge = badges.where((badge) => badge.id == 'level_ten').first;
        await _firebaseService.sendNewBadgeNotification(badge: badge);
      }
    }
    return userRewardsModel;
  }
}
