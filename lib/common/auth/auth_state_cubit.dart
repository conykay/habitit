// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/domain/auth/usecases/logout_user.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';

import '../../service_locator.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(CheckingAuth()) {
    isAuthenticated();
  }

  StreamSubscription? _authSubscription;

  void isAuthenticated() async {
    _authSubscription =
        sl.get<UserLoggedInUseCase>().isLoggedIn().listen((isLoggedIn) {
      if (isLoggedIn) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    });
  }

  void logout() async {
    await sl.get<LogoutUserUseCase>().call();
    _authSubscription?.cancel();
  }
}
