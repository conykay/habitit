import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_state_cubit_test.mocks.dart';

@GenerateMocks([UserLoggedInUseCase])
void main() {
  late MockUserLoggedInUseCase userLoggedInUseCase;

  setUp(() {
    userLoggedInUseCase = MockUserLoggedInUseCase();
  });

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
