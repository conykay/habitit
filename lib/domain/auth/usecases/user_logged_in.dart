import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class UserLoggedInUseCase extends UseCase<bool, dynamic> {
  UserLoggedInUseCase(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Future<bool> call({params}) async {
    return true;
  }

  Stream<bool> isLoggedIn() {
    return _authenticationRepository.isLoggedIn();
  }
}
