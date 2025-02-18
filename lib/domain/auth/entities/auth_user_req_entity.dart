import 'package:equatable/equatable.dart';

class AuthUserReqEntity extends Equatable {
  final String email;
  final String password;
  final String name;
  const AuthUserReqEntity({
    this.name = '',
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password, name];
}
