import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/auth/repository/authentication_repository_impl_test.mocks.dart';
import 'auth_state_cubit_test.mocks.dart';

@GenerateMocks([UserLoggedInUseCase])
void main() {
  late MockUserLoggedInUseCase userLoggedInUseCase;

  setUp(() {
    userLoggedInUseCase = MockUserLoggedInUseCase();
  });

  final tUserAuth =
      AuthUserReqEntity(email: 'test@email.com', password: 'password');

  group('Authenticate User bloc', () {
    blocTest(
      'emits nothing when added',
      build: () => AuthStateCubit(userLoggedInUseCase),
      expect: () => [],
    );
  });

  blocTest('emits loading, loaded when create user is called',
      setUp: () {
        when(userLoggedInUseCase.call()).thenAnswer((_) async => true);
      },
      build: () => AuthStateCubit(userLoggedInUseCase),
      act: (bloc) => bloc.isAutheniticated(),
      expect: () => [Authenticated()],
      verify: (_) {
        verify(userLoggedInUseCase.call()).called(1);
      });
}
