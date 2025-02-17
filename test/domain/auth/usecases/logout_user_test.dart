import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/usecases/logout_user.dart';
import 'package:mockito/mockito.dart';

import 'authenticate_user_email_password_usecase_test.mocks.dart';

void main() {
  late MockAuthenticationRepository repository;
  late LogoutUserUseCase logoutUseCase;
  setUp(() {
    repository = MockAuthenticationRepository();
    logoutUseCase = LogoutUserUseCase(repository: repository);
  });

  test('When logout request success', () async {
    when(repository.logout()).thenAnswer((_) async => Right('done'));
    var result = await logoutUseCase.call();
    expect(result, Right('done'));
    verify(repository.logout()).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('When logout request fails', () async {
    when(repository.logout())
        .thenAnswer((_) async => Left(OtherFailure('failed')));
    var result = await logoutUseCase.call();
    expect(result, Left(OtherFailure('failed')));
    verify(repository.logout()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
