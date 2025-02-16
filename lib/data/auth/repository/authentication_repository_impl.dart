import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthFirebaseService firebaseService;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl(
      {required this.firebaseService, required this.networkInfo});

  @override
  Future<Either<Failures, UserCredential>> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    if (await networkInfo.hasConection) {
      try {
        var cred =
            await firebaseService.createUserEmailPassword(authData: authData);
        return Right(cred);
      } catch (e) {
        return Left(OtherFailure(e.toString()));
      }
    } else {
      return Left(OtherFailure('No connection'));
    }
  }
}
