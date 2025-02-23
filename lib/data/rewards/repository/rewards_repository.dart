// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

import '../../../core/network/network_info.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsHiveService _hiveService;
  final RewardsFirebaseService _firebaseService;
  final NetworkInfo _networkInfo;
  RewardsRepositoryImpl({
    required RewardsHiveService hiveService,
    required RewardsFirebaseService firebaseService,
    required NetworkInfo networkInfo,
  })  : _firebaseService = firebaseService,
        _hiveService = hiveService,
        _networkInfo = networkInfo;

  @override
  Future<Either> updateUserRewards({required int xpAmmount}) async {
    var isOnline = await _networkInfo.hasConection;
    late UserRewardsModel userRewardsModel;
    try {
      if (isOnline) {
        userRewardsModel = await _firebaseService.getUserRewards();
        var editedReward = _updateReward(userRewardsModel, xpAmmount);
        await _firebaseService
            .updateUserRewards(rewardModel: editedReward)
            .then((_) async => await _hiveService.updateUserRewards(
                rewardModel: editedReward));
      } else {
        userRewardsModel = await _hiveService.getUserRewards();
        var editedReward = _updateReward(userRewardsModel, xpAmmount);
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
    var isOnline = await _networkInfo.hasConection;
    late UserRewardsModel userReward;
    try {
      if (isOnline) {
        var localReward = await _hiveService.getUserRewards();
        var remoteReward = await _firebaseService.getUserRewards();
        if (!localReward.synced || !localReward.isInBox) {
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

  UserRewardsModel _updateReward(
      UserRewardsModel userRewardsModel, int xpAmmount) {
    userRewardsModel.xp += xpAmmount;
    if (xpAmmount == 10) {
      userRewardsModel.earnedBadges.add('first_Habit');
    }
    int newLevel = (userRewardsModel.xp ~/ 100) + 1;
    if (newLevel > userRewardsModel.level) {
      userRewardsModel.level = newLevel;
    }
    if (userRewardsModel.level == 10) {
      userRewardsModel.earnedBadges.add('level_ten');
    }
    return userRewardsModel;
  }
}
