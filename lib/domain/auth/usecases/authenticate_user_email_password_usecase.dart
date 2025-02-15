import 'package:dartz/dartz.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../models/auth_user_req.dart';

class AuthenticateUserEmailPasswordUseCase {
  final AuthenticationRepository repository;

  AuthenticateUserEmailPasswordUseCase(this.repository);

  Future<Either<Failures, dynamic>> execute(
      {required AuthUserReq authUserReq}) async {
    return await repository.authUserEmailPassword(authData: authUserReq);
  }
}
