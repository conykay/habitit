// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthComplete extends AuthState {
  UserCredential? userCredential;
  AuthComplete({
    this.userCredential,
  });
}

class AuthError extends AuthState {
  String? error;
  AuthError({
    this.error,
  });
}
