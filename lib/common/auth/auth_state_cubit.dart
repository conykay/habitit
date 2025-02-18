// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/auth/auth_state.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';

class AuthStateCubit extends Cubit<AuthState> {
  final UserLoggedInUseCase usecase;
  AuthStateCubit(this.usecase) : super(CheckingAuth());
  void isAutheniticated() async {
    var isLoggedIn = await usecase.call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
