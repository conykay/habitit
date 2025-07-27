import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/repository/authentication_repository_impl_test.mocks.dart';
import 'authenticate_user_email_password_usecase_test.mocks.dart';

void main() {
  late MockAuthenticationRepository repository;
  late SignInGoogleUseCase googleUseCase;
  setUp(() {
    repository = MockAuthenticationRepository();
    googleUseCase = SignInGoogleUseCase(repository);
  });
  final userCred = MockUserCredential();

  test('When google signin request success', () async {
    when(repository.googleSignIn()).thenAnswer((_) async => Right(userCred));
    var cred = await googleUseCase.call();
    expect(cred, Right(userCred));
    verify(repository.googleSignIn()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
