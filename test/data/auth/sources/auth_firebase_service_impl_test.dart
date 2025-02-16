import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_firebase_service_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential])
void main() {
  late MockFirebaseAuth auth;
  late AuthFirebaseServiceImpl impl;

  final tAuthUser =
      AuthUserReqEntity(email: 'test@email.com', password: 'testPass');

  group('create user requested', () {
    setUp(() {
      auth = MockFirebaseAuth();
      impl = AuthFirebaseServiceImpl(auth: auth);
    });

    test('user request successfuly', () async {
      when(auth.createUserWithEmailAndPassword(
              email: tAuthUser.email, password: tAuthUser.password))
          .thenAnswer((_) async => Future.value(MockUserCredential()));
      await impl.createUserEmailPassword(authData: tAuthUser);
      verify(auth.createUserWithEmailAndPassword(
              email: tAuthUser.email, password: tAuthUser.password))
          .called(1);
    });
  });
  group('Sign in user requested', () {
    setUp(() {
      auth = MockFirebaseAuth();
      impl = AuthFirebaseServiceImpl(auth: auth);
    });

    test('user request successfuly', () async {
      when(auth.signInWithEmailAndPassword(
              email: tAuthUser.email, password: tAuthUser.password))
          .thenAnswer((_) async => Future.value(MockUserCredential()));
      await impl.signinUserEmailPassword(authData: tAuthUser);
      verify(auth.signInWithEmailAndPassword(
              email: tAuthUser.email, password: tAuthUser.password))
          .called(1);
    });
  });
}
