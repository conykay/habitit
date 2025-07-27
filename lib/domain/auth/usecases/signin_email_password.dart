import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

typedef SignInEmailPasswordData = Either<Failures, UserCredential>;

class SignInEmailPasswordUseCase
    extends UseCase<SignInEmailPasswordData, AuthUserReqEntity> {
  SignInEmailPasswordUseCase();

  @override
  Future<SignInEmailPasswordData> call({AuthUserReqEntity? params}) {
    return sl
        .get<AuthenticationRepository>()
        .signInUserEmailPassword(authData: params!);
  }
}
