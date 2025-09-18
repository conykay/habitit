import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class CreateUserEmailPasswordUseCase
    extends UseCase<Either, AuthUserReqEntity> {
  CreateUserEmailPasswordUseCase(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Either> call({AuthUserReqEntity? params}) async {
    return await _authenticationRepository.createUserEmailPassword(
        authData: params!);
  }
}
