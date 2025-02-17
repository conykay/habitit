import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/data/auth/models/user_creation_req.dart';

void main() {
  group('UserCreationReq', () {
    final tUserCreationReq = UserCreationReq(
      name: 'Test User',
      email: 'test@example.com',
      userId: '12345',
    );

    test('should convert UserCreationReq to Map', () {
      final result = tUserCreationReq.toMap();
      expect(result, {
        'name': 'Test User',
        'email': 'test@example.com',
        'userId': '12345',
      });
    });

    test('should create UserCreationReq from Map', () {
      final map = {
        'name': 'Test User',
        'email': 'test@example.com',
        'userId': '12345',
      };
      final result = UserCreationReq.fromMap(map);
      expect(result, tUserCreationReq);
    });

    test('should convert UserCreationReq to JSON', () {
      final result = tUserCreationReq.toJson();
      expect(result,
          '{"name":"Test User","email":"test@example.com","userId":"12345"}');
    });

    test('should create UserCreationReq from JSON', () {
      final jsonString =
          '{"name":"Test User","email":"test@example.com","userId":"12345"}';
      final result = UserCreationReq.fromJson(jsonString);
      expect(result, tUserCreationReq);
    });
  });
}
