// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

class AuthUserReqModel extends AuthUserReqEntity {
  const AuthUserReqModel({
    required super.email,
    required super.password,
  });
}
