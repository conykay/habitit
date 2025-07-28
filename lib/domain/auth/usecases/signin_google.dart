import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

typedef SignInGoogleData = Either<Failures, UserCredential>;

class SignInGoogleUseCase extends UseCase<SignInGoogleData, dynamic> {
  SignInGoogleUseCase();

  @override
  Future<SignInGoogleData> call({params}) {
    return sl.get<AuthenticationRepository>().googleSignIn();
  }
}
