// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';

import '../../core/usecase/usecase.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(CheckingAuth());
  void isAutheniticated({required UseCase usecase}) async {
    var isLoggedIn = await usecase.call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  void logout({required UseCase usecase}) async {
    emit(CheckingAuth());
    await usecase.call();
    emit(UnAuthenticated());
  }
}
