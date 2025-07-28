// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/domain/auth/usecases/logout_user.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';

import '../../service_locator.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(CheckingAuth());

  void isAuthenticated() async {
    var isLoggedIn = await sl.get<UserLoggedInUseCase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  void logout() async {
    emit(CheckingAuth());
    await sl.get<LogoutUserUseCase>().call();
    emit(UnAuthenticated());
  }
}
