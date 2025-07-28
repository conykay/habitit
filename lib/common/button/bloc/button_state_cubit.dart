import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/button/bloc/button_state.dart';

import '../../../core/usecase/usecase.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonState(state: ButtonStates.initial));
  Future<void> call({dynamic params, required UseCase usecase}) async {
    emit(ButtonState(state: ButtonStates.loading));
    try {
      Either data = await usecase.call(params: params);
      data.fold(
          (error) =>
              emit(ButtonState(state: ButtonStates.failed, error: error)),
          (result) =>
              emit(ButtonState(state: ButtonStates.loaded, data: result)));
    } catch (e) {
      emit(ButtonState(state: ButtonStates.failed, error: e.toString()));
    }
  }
}
