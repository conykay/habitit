import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_rewards_model.dart';

abstract class RewardsFirebaseService {
  Future<UserRewardsModel> getUserRewards();
  Future<void> updateUserRewards({required UserRewardsModel rewardModel});
}

class RewardsFirebaseServiceImpl implements RewardsFirebaseService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<UserRewardsModel> getUserRewards() async {
    try {
      var doc = await ref
          .doc(user!.uid)
          .collection('Rewards')
          .doc('user_rewards')
          .get();
      return UserRewardsModel.fromMap(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRewards(
      {required UserRewardsModel rewardModel}) async {
    try {
      var docRef = ref.doc(user!.uid).collection('Rewards').doc('user_rewards');
      rewardModel.synced = true;
      await docRef.set(rewardModel.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
