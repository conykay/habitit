import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/data/notifications/source/notification_service.dart';
import 'package:habitit/data/rewards/models/user_rewards_model.dart';

import '../../../domain/auth/entities/auth_user_req_entity.dart';
import '../../../service_locator.dart';
import '../models/user_creation_req.dart';

abstract class AuthFirebaseService {
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData});

  Future<UserCredential> signInUserEmailPassword(
      {required AuthUserReqEntity authData});

  Future<UserCredential> googleSignIn();

  Future<void> logout();

  Stream<bool> isLoggedIn();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthFirebaseServiceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _googleSignIn = googleSignIn,
        _auth = auth;
// default rewards for new users
  final Map<String, dynamic> _defaultRewards =
      UserRewardsNetworkModel(xp: 0, level: 1, earnedBadges: []).toJson();

  // create user with email and password
  @override
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');

    try {
      // Create a new user with email and password
      var cred = await _auth.createUserWithEmailAndPassword(
          email: authData.email, password: authData.password);
      // Add the user's data to the "Users" collection
      await userCollectionRef.doc(cred.user!.uid).set(UserCreationReq(
              name: authData.name,
              email: authData.email,
              userId: cred.user!.uid)
          .toMap());
      // Add the default rewards document to the "Rewards" collection
      await userCollectionRef
          .doc(cred.user!.uid)
          .collection('Rewards')
          .doc('user_rewards')
          .set(_defaultRewards);
      //store device token for notifications
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      throw Exception(
          'Failed to create user with email and password error: $e');
    }
  }

  // sign in user with email and password
  @override
  Future<UserCredential> signInUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    try {
      // Sign in the user with email and password
      var cred = await _auth.signInWithEmailAndPassword(
          email: authData.email, password: authData.password);
      //store device token for notifications
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      throw Exception('Failed to sign in with email and password error: $e');
    }
  }

  // sign in user with google
  @override
  Future<UserCredential> googleSignIn() async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Check if the platform is web
    try {
      late final AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;

        credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      }
      // Sign in the user with the credential
      var cred = await _auth.signInWithCredential(credential);
      // Check if the user's data already exists in the "Users" collection
      var userData = await userCollectionRef
          .where('userId', isEqualTo: cred.user!.uid)
          .get();
      if (userData.docs.isEmpty) {
        // Add the user's data to the "Users" collection
        await userCollectionRef.doc(cred.user!.uid).set(UserCreationReq(
                name: cred.user!.displayName!,
                email: cred.user!.email!,
                userId: cred.user!.uid)
            .toMap());
        // Add the default rewards document to the "Rewards" collection
        await userCollectionRef
            .doc(cred.user!.uid)
            .collection('Rewards')
            .doc('user_rewards')
            .set(_defaultRewards);
      }
      //store device token for notifications
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      throw Exception('Failed to sign in with Google error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout error: $e');
    }
  }

  @override
  Stream<bool> isLoggedIn() {
    var controller = StreamController<bool>();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        controller.add(false);
      } else {
        controller.add(true);
      }
    });
    return controller.stream;
  }

// store token for notifications
  void onUserLoggedIn(User user) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the device token
    final notificationService = sl.get<NotificationService>();

    try {
      final token = await notificationService.getToken();
      if (token != null) {
        await userCollectionRef.doc(user.uid).update({'token': token});
      }
      // token refresh
      notificationService.listenToTokenRefresh((newToken) async {
        userCollectionRef.doc(user.uid).update({'token': newToken});
      });
    } catch (e) {
      throw Exception('Failed to store user token error: $e');
    }
  }
}
