import 'package:dartz/dartz.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthFirebaseService _authFirebaseService;
  final NetworkInfoService _networkInfoService;

  AuthenticationRepositoryImpl({
    required AuthFirebaseService authFirebaseService,
    required NetworkInfoService networkInfoService,
  })  : _authFirebaseService = authFirebaseService,
        _networkInfoService = networkInfoService;

  @override
  Future<Either> createUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    // Check if there is a connection
    final bool hasConnection = await _networkInfoService.hasConnection;
    if (hasConnection) {
      try {
        // Create a new user with email and password
        var cred =
            _authFirebaseService.createUserEmailPassword(authData: authData);
        return Right(cred);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left('check network connection');
    }
  }

  @override
  Future<Either> signInUserEmailPassword(
      {required AuthUserReqEntity authData}) async {
    // Check if there is a connection
    final bool hasConnection = await _networkInfoService.hasConnection;
    if (hasConnection) {
      try {
        // Sign in the user with email and password
        var cred = await _authFirebaseService.signInUserEmailPassword(
            authData: authData);
        return Right(cred);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left('check network connection');
    }
  }

  @override
  Future<Either> googleSignIn() async {
    // Check if there is a connection
    final bool hasConnection = await _networkInfoService.hasConnection;
    if (hasConnection) {
      try {
        // Sign in the user with google
        var cred = _authFirebaseService.googleSignIn();
        return Right(cred);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left('check network connection');
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await _authFirebaseService.logout();
      return Right('Logged out');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<bool> isLoggedIn() {
    return _authFirebaseService.isLoggedIn();
  }
}
