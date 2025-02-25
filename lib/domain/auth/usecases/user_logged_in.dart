import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class UserLoggedInUseCase extends UseCase<bool, dynamic> {
  final AuthenticationRepository repository;
  UserLoggedInUseCase(this.repository);

  @override
  Future<bool> call({params}) async {
    return await repository.isLoggedIn();
  }
}
