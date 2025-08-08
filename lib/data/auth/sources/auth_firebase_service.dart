import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/core/platform_info/platform_info.dart';
import 'package:habitit/data/notifications/source/firebase_messaging_service.dart';
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
  final userCollectionRef = FirebaseFirestore.instance.collection('Users');
  final auth = FirebaseAuth.instance;

  GoogleSignIn get _googleSignIn => GoogleSignIn.standard();

  @override
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    try {
      var cred = await auth.createUserWithEmailAndPassword(
          email: authData.email, password: authData.password);
      await userCollectionRef.doc(cred.user!.uid).set(UserCreationReq(
              name: authData.name,
              email: authData.email,
              userId: cred.user!.uid)
          .toMap());
      await userCollectionRef
          .doc(cred.user!.uid)
          .collection('Rewards')
          .doc('user_rewards')
          .set(UserRewardsModel(xp: 0, level: 1, earnedBadges: [], synced: true)
              .toMap());
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    try {
      var cred = await auth.signInWithEmailAndPassword(
          email: authData.email, password: authData.password);
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> googleSignIn() async {
    try {
      late final AuthCredential credential;
      if (sl.get<PlatformInfoService>().isWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await auth.signInWithPopup(googleProvider);
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;

        credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      }

      var cred = await auth.signInWithCredential(credential);
      var userData = await userCollectionRef
          .where('userId', isEqualTo: cred.user!.uid)
          .get();
      if (userData.docs.isEmpty) {
        await userCollectionRef.doc(cred.user!.uid).set(UserCreationReq(
                name: cred.user!.displayName!,
                email: cred.user!.email!,
                userId: cred.user!.uid)
            .toMap());
        await userCollectionRef
            .doc(cred.user!.uid)
            .collection('Rewards')
            .doc('user_rewards')
            .set(UserRewardsModel(
                    xp: 0, level: 1, earnedBadges: [], synced: true)
                .toMap());
      }
      onUserLoggedIn(cred.user!);
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<bool> isLoggedIn() {
    var controller = StreamController<bool>();
    auth.authStateChanges().listen((User? user) {
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
    final notificationService = NotificationServiceImpl();
    final token = await notificationService.getToken();
    if (token != null) {
      await userCollectionRef.doc(user.uid).update({'token': token});
    }
    // token refresh
    notificationService.listenToTokenRefresh((newToken) async {
      userCollectionRef.doc(user.uid).update({'token': newToken});
    });
  }
}
