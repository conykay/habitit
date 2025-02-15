import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../models/auth_user_req.dart';

abstract class AuthenticationRepository {
  Future<Either<Failures, dynamic>> authUserEmailPassword(
      {required AuthUserReq authData});
}
