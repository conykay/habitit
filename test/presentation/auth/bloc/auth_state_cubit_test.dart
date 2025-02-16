import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/presentation/auth/bloc/auth_state.dart';
import 'package:habitit/presentation/auth/bloc/auth_state_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../data/auth/sources/auth_firebase_service_impl_test.mocks.dart';
import 'auth_state_cubit_test.mocks.dart';

@GenerateMocks([CreateUserEmailPasswordUseCase])
void main() {
  late MockCreateUserEmailPasswordUseCase useCase;

  setUp(() {
    useCase = MockCreateUserEmailPasswordUseCase();
  });

  final tUserAuth =
      AuthUserReqEntity(email: 'test@email.com', password: 'password');

  group('create User bloc', () {
    blocTest(
      'emits nothing when added',
      build: () => AuthStateCubit(),
      expect: () => [],
    );
  });

  blocTest('emits loading, loaded when create user is called',
      setUp: () {
        when(useCase.call(params: tUserAuth))
            .thenAnswer((_) async => Right(MockUserCredential()));
      },
      build: () => AuthStateCubit(),
      act: (bloc) => bloc.createUserWithEmailPassword(
          authInfo: tUserAuth, useCase: useCase),
      expect: () => [isA<AuthLoading>(), isA<AuthComplete>()],
      verify: (_) {
        verify(useCase.call(params: tUserAuth)).called(1);
      });
}
