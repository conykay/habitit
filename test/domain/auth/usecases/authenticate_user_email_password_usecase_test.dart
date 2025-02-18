import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/repository/authentication_repository_impl_test.mocks.dart';
import 'authenticate_user_email_password_usecase_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late CreateUserEmailPasswordUseCase usecase;
  late MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUserEmailPasswordUseCase(repository);
  });

  final tAuthUserReq =
      AuthUserReqEntity(email: 'test@test.com', password: 'testPass');
  final userCred = MockUserCredential();
  test('Success passing the user creation request', () async {
    when(repository.createUserEmailPassword(authData: tAuthUserReq))
        .thenAnswer((_) async => Right(userCred));

    var result = await usecase.call(params: tAuthUserReq);

    expect(result, Right(userCred));

    verify(repository.createUserEmailPassword(authData: tAuthUserReq));
    verifyNoMoreInteractions(repository);
  });
  test('When fail passing user creation request', () async {
    when(repository.createUserEmailPassword(authData: tAuthUserReq))
        .thenAnswer((_) async => Left(OtherFailure('auth failed')));

    var result = await usecase.call(params: tAuthUserReq);
    expect(result, Left(OtherFailure('auth failed')));
    verify(repository.createUserEmailPassword(authData: tAuthUserReq));
    verifyNoMoreInteractions(repository);
  });
}
