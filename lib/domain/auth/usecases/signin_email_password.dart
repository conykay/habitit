import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class SigninEmailPasswordUseCase
    extends UseCase<Either<Failures, UserCredential>, AuthUserReqEntity> {
  final AuthenticationRepository repository;
  SigninEmailPasswordUseCase(this.repository);

  @override
  Future<Either> call({AuthUserReqEntity? params}) {
    return repository.signinUserEmailPassword(authData: params!);
  }
}
