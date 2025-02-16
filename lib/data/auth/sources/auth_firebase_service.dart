import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/core/platform_info/platform_info.dart';

import '../../../domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthFirebaseService {
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<UserCredential> signinUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<UserCredential> googleSignin();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth auth;
  final GoogleSignIn _googleSignIn;
  final PlatformInfo _info;

  AuthFirebaseServiceImpl(
      {required this.auth,
      GoogleSignIn? googleSignIn,
      PlatformInfo? platformInfo})
      : _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _info = platformInfo ?? PlatformInfoImpl();
  @override
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    try {
      return await auth.createUserWithEmailAndPassword(
          email: authData.email, password: authData.password);
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
      return cred;
    } catch (e) {
      rethrow;
    }
  }
}
