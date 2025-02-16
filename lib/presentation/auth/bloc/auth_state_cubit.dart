// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/presentation/auth/bloc/auth_state.dart';

import '../../../domain/auth/entities/auth_user_req_entity.dart';

class AuthStateCubit extends Cubit<AuthState> {
  AuthStateCubit() : super(AuthInitial());

  void createUserWithEmailPassword({
    required AuthUserReqEntity authInfo,
    required CreateUserEmailPasswordUseCase useCase,
  }) async {
    emit(AuthLoading());
    var response = await useCase.call(params: authInfo);
    response.fold((e) => emit(AuthError()),
        (data) => emit(AuthComplete(userCredential: data)));
  }

  void signinUserEmailPassword({
    required AuthUserReqEntity authInfo,
    required SigninEmailPasswordUseCase useCase,
  }) async {
    emit(AuthLoading());
    var response = await useCase.call(params: authInfo);
    response.fold((e) => emit(AuthError()),
        (data) => emit(AuthComplete(userCredential: data)));
  }
}
