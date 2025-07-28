import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

class UserLoggedInUseCase extends UseCase<bool, dynamic> {
  UserLoggedInUseCase();

  @override
  Future<bool> call({params}) async {
    return await sl.get<AuthenticationRepository>().isLoggedIn();
  }
}
