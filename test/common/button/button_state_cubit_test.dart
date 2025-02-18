import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../presentation/auth/bloc/auth_state_cubit_test.mocks.dart';

void main() {
  late MockSigninGoogleUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSigninGoogleUseCase();
  });

  final tParams = {'param1': 'value1'};
  final tResult = 'result';

  group('ButtonStateCubit', () {
    blocTest<ButtonStateCubit, ButtonState>(
      'emits [loading, loaded] when usecase call is successful',
      setUp: () {
        when(mockUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => Right(tResult));
      },
      build: () => ButtonStateCubit(),
      act: (cubit) => cubit.call(params: tParams, usecase: mockUseCase),
      expect: () => [
        ButtonState(state: Buttonstate.loading),
        ButtonState(state: Buttonstate.loaded, data: tResult),
      ],
      verify: (_) {
        verify(mockUseCase.call(params: tParams)).called(1);
      },
    );

    blocTest<ButtonStateCubit, ButtonState>(
      'emits [loading, failed] when usecase call fails',
      setUp: () {
        when(mockUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => Left('error'));
      },
      build: () => ButtonStateCubit(),
      act: (cubit) => cubit.call(params: tParams, usecase: mockUseCase),
      expect: () => [
        ButtonState(state: Buttonstate.loading),
        ButtonState(state: Buttonstate.failed, error: 'error'),
      ],
      verify: (_) {
        verify(mockUseCase.call(params: tParams)).called(1);
      },
    );
  });
}
