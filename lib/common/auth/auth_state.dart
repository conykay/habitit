// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class CheckingAuth extends AuthState {
  @override
  List<Object?> get props => [];
}
