import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class SignInGoogleUseCase extends UseCase<Either, dynamic> {
  SignInGoogleUseCase(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<Either> call({params}) {
    return _authenticationRepository.googleSignIn();
  }
}
