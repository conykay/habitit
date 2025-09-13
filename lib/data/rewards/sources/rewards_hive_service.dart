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
  static Future<RewardsHiveServiceImpl> getInstance() async {
    final user = FirebaseAuth.instance.currentUser;
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

  @override
  Future<UserRewardEntity> getUserRewards() async {
    if (!_rewardBox.isOpen) {
      throw Exception('Reward box not open when getUserRewards() called ');
    }
    try {
      final reward = _rewardBox.get(0);
      return reward ?? UserRewardEntity();
    } catch (e) {
      throw Exception('From Hive Service getUserRewards(): ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserRewards(
      {required UserRewardEntity rewardModel}) async {
    if (!_rewardBox.isOpen) {
      throw Exception('Reward box not open when updateUserRewards() called ');
    }
    try {
      await _rewardBox.put(0, rewardModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    if (_rewardBox.isOpen) {
      return _rewardBox.close();
    }
  }
}
