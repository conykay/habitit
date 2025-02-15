import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../models/auth_user_req.dart';

class AuthenticateUserEmailPasswordUseCase
    extends UseCase<Either, AuthUserReq> {
  final AuthenticationRepository repository;

  AuthenticateUserEmailPasswordUseCase(this.repository);

  @override
  Future<Either> call({AuthUserReq? params}) async {
    return await repository.authUserEmailPassword(authData: params!);
  }
}
