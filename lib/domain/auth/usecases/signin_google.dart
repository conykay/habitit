import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class SigninGoogleUseCase
    extends UseCase<Either<Failures, UserCredential>, dynamic> {
  final AuthenticationRepository repository;
  SigninGoogleUseCase(this.repository);

  @override
  Future<Either<Failures, UserCredential>> call({params}) {
    return repository.googleSignin();
  }
}
