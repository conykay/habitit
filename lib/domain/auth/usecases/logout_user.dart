// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

import '../../../service_locator.dart';

typedef LogoutUserData = Either<Failures, dynamic>;

class LogoutUserUseCase extends UseCase<LogoutUserData, dynamic> {
  LogoutUserUseCase();

  @override
  Future<LogoutUserData> call({params}) {
    return sl.get<AuthenticationRepository>().logout();
  }
}
