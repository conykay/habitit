import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthFirebaseService {
  Future<UserCredential> createUserEmailPassword(
      {required AuthUserReqEntity authData});
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth auth;

  AuthFirebaseServiceImpl({required this.auth});
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
}
