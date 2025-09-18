import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class SignInEmailPasswordUseCase extends UseCase<Either, AuthUserReqEntity> {
  SignInEmailPasswordUseCase(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Either> call({AuthUserReqEntity? params}) {
    return _authenticationRepository.signInUserEmailPassword(authData: params!);
  }
}
