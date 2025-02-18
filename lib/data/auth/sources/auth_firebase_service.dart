import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/core/platform_info/platform_info.dart';

import '../../../domain/auth/entities/auth_user_req_entity.dart';
import '../models/user_creation_req.dart';

abstract class AuthFirebaseService {
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<UserCredential> signinUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<UserCredential> googleSignin();
  Future<void> logout();
  Future<bool> isLoggedIn();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth auth;
  final GoogleSignIn _googleSignIn;
  final PlatformInfo _info;
  final FirebaseFirestore firestore;

  AuthFirebaseServiceImpl(
      {required this.firestore,
      required this.auth,
      GoogleSignIn? googleSignIn,
      PlatformInfo? platformInfo})
      : _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _info = platformInfo ?? PlatformInfoImpl();
  final userCollectionRef = FirebaseFirestore.instance.collection('Users');

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
      return cred;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signinUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    try {
      return await auth.signInWithEmailAndPassword(
          email: authData.email, password: authData.password);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserCredential> googleSignin() async {
    try {
      late final AuthCredential credential;
      if (_info.isWeb) {
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
      }
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
  Future<bool> isLoggedIn() async {
    try {
      if (auth.currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
