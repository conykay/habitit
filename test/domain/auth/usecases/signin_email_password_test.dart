import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/sources/auth_firebase_service_impl_test.mocks.dart';
import 'authenticate_user_email_password_usecase_test.mocks.dart';

void main() {
  late MockAuthenticationRepository authRepository;
  late SigninEmailPasswordUseCase useCase;

  setUp(() {
    authRepository = MockAuthenticationRepository();
    useCase = SigninEmailPasswordUseCase(authRepository);
  });

  final tAuthUser =
      AuthUserReqEntity(email: 'test@email.com', password: 'password');
  final userCred = MockUserCredential();

  test('when success pass signin request', () async {
    when(authRepository.signinUserEmailPassword(authData: tAuthUser))
        .thenAnswer((_) async => Right(userCred));

    var result = await useCase.call(params: tAuthUser);
    expect(result, Right(userCred));
    verify(authRepository.signinUserEmailPassword(authData: tAuthUser))
        .called(1);
    verifyNoMoreInteractions(authRepository);
  });

  test('When sign in request fails', () async {
    when(authRepository.signinUserEmailPassword(authData: tAuthUser))
        .thenAnswer((_) async => Left(OtherFailure('auth failed')));
    var result = await useCase.call(params: tAuthUser);
    expect(result, Left(OtherFailure('auth failed')));
    verify(authRepository.signinUserEmailPassword(authData: tAuthUser))
        .called(1);
    verifyNoMoreInteractions(authRepository);
  });
}
