import 'package:dartz/dartz.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthenticationRepository {
  Future<Either> createUserEmailPassword({required AuthUserReqEntity authData});

  Future<Either> signInUserEmailPassword({required AuthUserReqEntity authData});

  Future<Either> googleSignIn();

  Future<Either> logout();

  Stream<bool> isLoggedIn();
}
