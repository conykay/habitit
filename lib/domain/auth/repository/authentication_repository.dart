import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failures, UserCredential>> createUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<Either<Failures, UserCredential>> signinUserEmailPassword(
      {required AuthUserReqEntity authData});
  Future<Either<Failures, UserCredential>> googleSignin();
  Future<Either<Failures, dynamic>> logout();
  Future<bool> isLoggedIn();
}
