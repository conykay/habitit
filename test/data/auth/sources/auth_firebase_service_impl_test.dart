/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/core/platform_info/platform_info.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_firebase_service_impl_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  GoogleAuthProvider,
  GoogleSignIn,
  PlatformInfoImpl
])
void main() {
  late MockFirebaseAuth auth;
  late AuthFirebaseServiceImpl impl;
  late MockGoogleAuthProvider googleAuthProvider;
  late MockGoogleSignIn googleSignIn;
  late MockPlatformInfoImpl infoImpl;

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
 */
/*   group('signin with google request', () {
    setUp(() {
      auth = MockFirebaseAuth();
      googleAuthProvider = MockGoogleAuthProvider();
      googleSignIn = MockGoogleSignIn();
      infoImpl = MockPlatformInfoImpl();
      impl = AuthFirebaseServiceImpl(
          auth: auth, googleSignIn: googleSignIn, platformInfo: infoImpl);
    });

    group('is web', () {
      test('check is web', () async {
        when(infoImpl.isWeb).thenReturn(true);
        when(auth.signInWithPopup(any))
            .thenAnswer((_) async => MockUserCredential());
        await impl.googleSignin();
        var isweb = infoImpl.isWeb;
        expect(isweb, true);
      });
    });
  }); */

//   //Implement google sign in test.
// }
