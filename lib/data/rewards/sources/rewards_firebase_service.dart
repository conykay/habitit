import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/data/notifications/source/notification_service.dart';
import 'package:habitit/data/rewards/models/badge_model.dart';

import '../../../service_locator.dart';
import '../models/user_rewards_model.dart';

abstract class RewardsFirebaseService {
  Future<UserRewardsNetworkModel> getUserRewards();

  Future<void> updateUserRewards(
      {required UserRewardsNetworkModel rewardModel});

  Future<void> sendNewBadgeNotification({required BadgeModel badge});
}

class RewardsFirebaseServiceImpl implements RewardsFirebaseService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<UserRewardsNetworkModel> getUserRewards() async {
    try {
      var doc = await ref
          .doc(user!.uid)
          .collection('Rewards')
          .doc('user_rewards')
          .get();
      return UserRewardsNetworkModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserRewards(
      {required UserRewardsNetworkModel rewardModel}) async {
    try {
      var docRef = ref.doc(user!.uid).collection('Rewards').doc('user_rewards');
      await docRef.set(rewardModel.toJson()).then((_) => rewardModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendNewBadgeNotification({required BadgeModel badge}) async {
    try {
      await sl.get<NotificationService>().sendNewBadgeNotification(
          uid: user!.uid,
          badgeName: badge.name,
          badgeDescription: badge.description);
    } catch (e) {
      rethrow;
    } finally {
      print('Attempted to send notification');
    }
  }
}
