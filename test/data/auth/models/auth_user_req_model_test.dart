import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/data/auth/models/auth_user_req_model.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';

void main() {
  final tUserReqModel =
      AuthUserReqModel(email: 'test@email.com', password: 'testPass');
  test('Should be subclass of AuthUserReqEnity', () {
    expect(tUserReqModel, isA<AuthUserReqEntity>());
  });
}
