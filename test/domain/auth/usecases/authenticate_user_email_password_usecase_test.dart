import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';
import 'package:habitit/domain/auth/usecases/authenticate_user_email_password_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/sources/auth_firebase_service_impl_test.mocks.dart';
import 'authenticate_user_email_password_usecase_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late AuthenticateUserEmailPasswordUseCase usecase;
  late MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AuthenticateUserEmailPasswordUseCase(repository);
  });

  final tAuthUserReq =
      AuthUserReqEntity(email: 'test@test.com', password: 'testPass');
  final userCred = MockUserCredential();
  test('When pass user creation request', () async {
    when(repository.createUserEmailPassword(authData: tAuthUserReq))
        .thenAnswer((_) async => Right(userCred));

    var result = await usecase.call(params: tAuthUserReq);

    expect(result, Right(userCred));

    verify(repository.createUserEmailPassword(authData: tAuthUserReq));
    verifyNoMoreInteractions(repository);
  });
  test('When fail user creation request', () async {
    when(repository.createUserEmailPassword(authData: tAuthUserReq))
        .thenAnswer((_) async => Left(OtherFailure('auth failed')));

    var result = await usecase.call(params: tAuthUserReq);
    expect(result, Left(OtherFailure('auth failed')));
    verify(repository.createUserEmailPassword(authData: tAuthUserReq));
    verifyNoMoreInteractions(repository);
  });
}
