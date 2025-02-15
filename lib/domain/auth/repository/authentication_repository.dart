import 'package:dartz/dartz.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

abstract class AuthenticationRepository {
  Future<Either> authUserEmailPassword({required AuthUserReqEntity authData});
}
