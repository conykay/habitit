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
  User? _user = FirebaseAuth.instance.currentUser;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  RewardsFirebaseServiceImpl() {
    _initUser();
  }

  void _initUser() {
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Future<UserRewardsNetworkModel> getUserRewards() async {
    try {
      if (_user == null) _initUser();
      var doc = await ref
          .doc(_user!.uid)
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
      if (_user == null) _initUser();
      var docRef =
          ref.doc(_user!.uid).collection('Rewards').doc('user_rewards');
      await docRef.set(rewardModel.toJson()).then((_) => rewardModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendNewBadgeNotification({required BadgeModel badge}) async {
    try {
      if (_user == null) _initUser();
      await sl.get<NotificationService>().sendNewBadgeNotification(
          uid: _user!.uid,
          badgeName: badge.name,
          badgeDescription: badge.description);
    } catch (e) {
      rethrow;
    } finally {
      print('Attempted to send notification');
    }
  }
}
