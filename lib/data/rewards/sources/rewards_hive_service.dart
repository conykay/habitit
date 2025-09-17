import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../core/db/hive_core.dart';

abstract class RewardsHiveService implements HiveCore {
  Future<UserRewardEntity> getUserRewards();

  Future<void> updateUserRewards({required UserRewardEntity rewardModel});
}

class RewardsHiveServiceImpl implements RewardsHiveService {
  late final Box<UserRewardEntity> _rewardBox;

  RewardsHiveServiceImpl._(this._rewardBox);

  //factory constructor
  static Future<RewardsHiveServiceImpl> getInstance(
      {required FirebaseAuth auth}) async {
    //get the current user
    final User? user = auth.currentUser;
    //check if the reward box is open if not open it
    final boxName = 'rewards_${user?.uid}'.toLowerCase();
    Box<UserRewardEntity> rewardBox;

    if (Hive.isBoxOpen(boxName)) {
      rewardBox = Hive.box<UserRewardEntity>(boxName);
    } else {
      rewardBox = await Hive.openBox<UserRewardEntity>(boxName);
    }
    //return instance
    return RewardsHiveServiceImpl._(rewardBox);
  }

  //get the user rewards
  @override
  Future<UserRewardEntity> getUserRewards() async {
    //check if the reward box is open
    if (!_rewardBox.isOpen) {
      throw Exception(
          'Reward box not open when attempting to get user rewards.');
    }
    //get the user rewards from the reward box
    try {
      //check if the reward box is empty if not return the reward
      final reward = _rewardBox.get(0);
      return reward ?? UserRewardEntity();
    } catch (e) {
      throw Exception('Failed to get user rewards from reward box: $e');
    }
  }

  //update the user rewards
  @override
  Future<void> updateUserRewards(
      {required UserRewardEntity rewardModel}) async {
    //check if the reward box is open
    if (!_rewardBox.isOpen) {
      throw Exception(
          'Reward box not open when attempting to update user rewards.');
    }
    //update the user rewards in the reward box with the new reward model
    try {
      await _rewardBox.put(0, rewardModel);
    } catch (e) {
      throw Exception('Failed to update user rewards in reward box: $e');
    }
  }

  //close the reward box
  @override
  Future<void> close() async {
    if (_rewardBox.isOpen) {
      return _rewardBox.close();
    }
  }
}
