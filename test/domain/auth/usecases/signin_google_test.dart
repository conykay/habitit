import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/repository/authentication_repository_impl_test.mocks.dart';
import 'authenticate_user_email_password_usecase_test.mocks.dart';

void main() {
  late MockAuthenticationRepository repository;
  late SigninGoogleUseCase googleUseCase;
  setUp(() {
    repository = MockAuthenticationRepository();
    googleUseCase = SigninGoogleUseCase(repository);
  });
  final userCred = MockUserCredential();

  test('When google signin request success', () async {
    when(repository.googleSignin()).thenAnswer((_) async => Right(userCred));
    var cred = await googleUseCase.call();
    expect(cred, Right(userCred));
    verify(repository.googleSignin()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
