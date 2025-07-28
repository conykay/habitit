import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../data/auth/repository/authentication_repository_impl_test.mocks.dart';
import 'button_state_cubit_test.mocks.dart';

@GenerateMocks([SignInGoogleUseCase])
void main() {
  late MockSigninGoogleUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSigninGoogleUseCase();
  });

  final tParams = {'param1': 'value1'};
  final tCred = MockUserCredential();

  group('ButtonStateCubit', () {
    blocTest<ButtonStateCubit, ButtonState>(
      'emits [loading, loaded] when usecase call is successful',
      setUp: () {
        when(mockUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tCred));
      },
      build: () => ButtonStateCubit(),
      act: (cubit) => cubit.call(params: tParams, usecase: mockUseCase),
      expect: () => [
        ButtonState(state: ButtonStates.loading),
        ButtonState(state: ButtonStates.loaded, data: tCred),
      ],
      verify: (_) {
        verify(mockUseCase.call(params: tParams)).called(1);
      },
    );

    blocTest<ButtonStateCubit, ButtonState>(
      'emits [loading, failed] when usecase call fails',
      setUp: () {
        when(mockUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => Left(OtherFailure('error')));
      },
      build: () => ButtonStateCubit(),
      act: (cubit) => cubit.call(params: tParams, usecase: mockUseCase),
      expect: () => [
        ButtonState(state: ButtonStates.loading),
        ButtonState(state: ButtonStates.failed, error: OtherFailure('error')),
      ],
      verify: (_) {
        verify(mockUseCase.call(params: tParams)).called(1);
      },
    );
  });
}
