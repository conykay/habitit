import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/presentation/auth/bloc/auth_state.dart';
import 'package:habitit/presentation/auth/bloc/auth_state_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/sources/auth_firebase_service_impl_test.mocks.dart';
import 'auth_state_cubit_test.mocks.dart';

@GenerateMocks([CreateUserEmailPasswordUseCase, SigninEmailPasswordUseCase])
void main() {
  late MockCreateUserEmailPasswordUseCase createUserUseCase;
  late MockSigninEmailPasswordUseCase signinUserUseCase;

  setUp(() {
    createUserUseCase = MockCreateUserEmailPasswordUseCase();
    signinUserUseCase = MockSigninEmailPasswordUseCase();
  });

  final tUserAuth =
      AuthUserReqEntity(email: 'test@email.com', password: 'password');

  group('Authenticate User bloc', () {
    blocTest(
      'emits nothing when added',
      build: () => AuthStateCubit(),
      expect: () => [],
    );
  });

  blocTest('emits loading, loaded when create user is called',
      setUp: () {
        when(createUserUseCase.call(params: tUserAuth))
            .thenAnswer((_) async => Right(MockUserCredential()));
      },
      build: () => AuthStateCubit(),
      act: (bloc) => bloc.createUserWithEmailPassword(
          authInfo: tUserAuth, useCase: createUserUseCase),
      expect: () => [isA<AuthLoading>(), isA<AuthComplete>()],
      verify: (_) {
        verify(createUserUseCase.call(params: tUserAuth)).called(1);
      });

  blocTest('emits loading, loaded when sigin user is called',
      setUp: () {
        when(signinUserUseCase.call(params: tUserAuth))
            .thenAnswer((_) async => Right(MockUserCredential()));
      },
      build: () => AuthStateCubit(),
      act: (bloc) => bloc.signinUserEmailPassword(
          authInfo: tUserAuth, useCase: signinUserUseCase),
      expect: () => [isA<AuthLoading>(), isA<AuthComplete>()],
      verify: (bloc) {
        verify(signinUserUseCase.call(params: tUserAuth)).called(1);
      });
}
