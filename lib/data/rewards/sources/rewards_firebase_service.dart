import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/data/notifications/source/notification_service.dart';
import 'package:habitit/data/rewards/models/badge_model.dart';

import '../models/user_rewards_model.dart';

abstract class RewardsFirebaseService {
  Future<UserRewardsNetworkModel> getUserRewards();

  Future<void> updateUserRewards(
      {required UserRewardsNetworkModel rewardModel});

  Future<void> sendNewBadgeNotification({required BadgeModel badge});
}

class RewardsFirebaseServiceImpl implements RewardsFirebaseService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;

  RewardsFirebaseServiceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required NotificationService notificationService,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _notificationService = notificationService;

  //get the users rewards
  @override
  Future<UserRewardsNetworkModel> getUserRewards() async {
    //Get a reference to the user rewards collection
    final CollectionReference ref = _firestore.collection('Users');
    //Get the current user
    final User? user = _firebaseAuth.currentUser;
    //get the user rewards
    try {
      //Check if the user rewards collection exists
      DocumentSnapshot<Map<String, dynamic>> doc = await ref
          .doc(user!.uid)
          .collection('Rewards')
          .doc('user_rewards')
          .get();
      //return the user rewards
      return UserRewardsNetworkModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(
          'Error while attempting to get user rewards from firestore: $e');
    }
  }

  //update the users rewards
  @override
  Future<void> updateUserRewards(
      {required UserRewardsNetworkModel rewardModel}) async {
//Get a reference to the user rewards collection
    final CollectionReference ref = _firestore.collection('Users');
    //Get the current user
    final User? user = _firebaseAuth.currentUser;
    //update the user rewards
    try {
      //Check if the user rewards collection exists
      DocumentReference docRef =
          ref.doc(user!.uid).collection('Rewards').doc('user_rewards');
      await docRef.set(rewardModel.toJson()).then((_) => rewardModel);
    } catch (e) {
      throw Exception(
          'Error while attempting to update user rewards in firestore: $e');
    }
  }

  //send a notification to the user
  @override
  Future<void> sendNewBadgeNotification({required BadgeModel badge}) async {
    //Get a reference to the user rewards collection
    final CollectionReference ref = _firestore.collection('Users');
    //Get the current user
    final User? user = _firebaseAuth.currentUser;
    //send a notification to the user
    try {
      //Send a notification to the user with the new badge name and description
      await _notificationService.sendNewBadgeNotification(
          uid: user!.uid,
          badgeName: badge.name,
          badgeDescription: badge.description);
    } catch (e) {
      throw Exception('Error while attempting to send notification: $e');
    } finally {
      print('Attempted to send notification');
    }
  }
}
