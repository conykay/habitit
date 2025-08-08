import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<Failures, UserCredential>> createUserEmailPassword(
      {required AuthUserReqEntity authData});

  Future<Either<Failures, UserCredential>> signInUserEmailPassword(
      {required AuthUserReqEntity authData});

  Future<Either<Failures, UserCredential>> googleSignIn();

  Future<Either<Failures, dynamic>> logout();

  Stream<bool> isLoggedIn();
}
