import 'package:dartz/dartz.dart';

import '../models/auth_user_req.dart';

abstract class AuthenticationRepository {
  Future<Either> authUserEmailPassword({required AuthUserReq authData});
}
