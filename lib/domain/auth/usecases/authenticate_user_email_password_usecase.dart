import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class AuthenticateUserEmailPasswordUseCase
    extends UseCase<Either, AuthUserReqEntity> {
  final AuthenticationRepository repository;

  AuthenticateUserEmailPasswordUseCase(this.repository);

  @override
  Future<Either> call({AuthUserReqEntity? params}) async {
    return await repository.authUserEmailPassword(authData: params!);
  }
}
