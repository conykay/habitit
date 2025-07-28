import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

typedef CreateUserEmailPasswordData = Either<Failures, UserCredential>;

class CreateUserEmailPasswordUseCase
    extends UseCase<CreateUserEmailPasswordData, AuthUserReqEntity> {
  CreateUserEmailPasswordUseCase();

  @override
  Future<CreateUserEmailPasswordData> call({AuthUserReqEntity? params}) async {
    return await sl
        .get<AuthenticationRepository>()
        .createUserEmailPassword(authData: params!);
  }
}
