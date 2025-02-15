// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AuthUserReq extends Equatable {
  final String email;
  final String password;
  const AuthUserReq({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
