import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  @override
  Future<Either<Failures, UserCredential>> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    if (await sl.get<NetworkInfoService>().hasConnection) {
      try {
        var cred = await sl
            .get<AuthFirebaseService>()
            .createUserEmailPassword(authData: authData);

        return Right(cred);
      } catch (e) {
        return Left(OtherFailure(e.toString()));
      }
    } else {
      return Left(OtherFailure('No connection'));
    }
  }

  @override
  Future<Either<Failures, UserCredential>> signInUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    if (await sl.get<NetworkInfoService>().hasConnection) {
      try {
        var cred = await sl
            .get<AuthFirebaseService>()
            .signInUserEmailPassword(authData: authData);
        return Right(cred);
      } catch (e) {
        return Left(OtherFailure(e.toString()));
      }
    } else {
      return Left(OtherFailure('check network connection'));
    }
  }

  @override
  Future<Either<Failures, UserCredential>> googleSignIn() async {
    if (await sl.get<NetworkInfoService>().hasConnection) {
      try {
        var cred = await sl.get<AuthFirebaseService>().googleSignIn();
        return Right(cred);
      } catch (e) {
        return Left(OtherFailure(e.toString()));
      }
    } else {
      return Left(OtherFailure('check network connection'));
    }
  }

  @override
  Future<Either<Failures, dynamic>> logout() async {
    try {
      await sl.get<AuthFirebaseService>().logout();
      return Right('done');
    } catch (e) {
      return Left(OtherFailure('error'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl.get<AuthFirebaseService>().isLoggedIn();
  }
}
