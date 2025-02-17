// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';

class LogoutUserUseCase extends UseCase<Either<Failures, dynamic>, dynamic> {
  final AuthenticationRepository repository;
  LogoutUserUseCase({
    required this.repository,
  });
  @override
  Future<Either> call({params}) {
    return repository.logout();
  }
}
