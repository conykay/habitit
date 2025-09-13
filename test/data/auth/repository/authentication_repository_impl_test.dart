import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/auth/repository/authentication_repository_impl.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthFirebaseService,
  NetworkInfoService,
  UserCredential,
])
void main() {
  late AuthenticationRepositoryImpl authenticationRepositoryImpl;
  late MockAuthFirebaseService mockAuthFirebaseService;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockAuthFirebaseService = MockAuthFirebaseService();
    mockNetworkInfo = MockNetworkInfo();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl(
        _firebaseService: mockAuthFirebaseService,
        networkInfo: mockNetworkInfo);
  });

  final tAuthUserReq =
      AuthUserReqEntity(email: 'test@email.com', password: 'testPass');

  group('Create user with email and password', () {
    test('Should check for internet connection', () async {
      //arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      //act
      await authenticationRepositoryImpl.createUserEmailPassword(
          authData: tAuthUserReq);
      //assert
      verify(mockNetworkInfo.hasConnection);
    });

    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      });

      test(
          'Should return user credential when user has been authenticated successfuly',
          () async {
        final tUsercred = MockUserCredential();
        //arrange
        when(mockAuthFirebaseService.createUserEmailPassword(
                authData: tAuthUserReq))
            .thenAnswer((_) async => tUsercred);
        //act
        var result = await authenticationRepositoryImpl.createUserEmailPassword(
            authData: tAuthUserReq);
        //assert
        verify(mockNetworkInfo.hasConnection).called(1);
        verify(mockAuthFirebaseService.createUserEmailPassword(
                authData: tAuthUserReq))
            .called(1);
        expect(result, Right(tUsercred));
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });

      test('error creating user', () async {
        when(mockAuthFirebaseService.createUserEmailPassword(
                authData: tAuthUserReq))
            .thenThrow(Exception());

        var result = await authenticationRepositoryImpl.createUserEmailPassword(
            authData: tAuthUserReq);

        expect(result, Left(OtherFailure(Exception().toString())));

        verify(mockAuthFirebaseService.createUserEmailPassword(
                authData: tAuthUserReq))
            .called(1);
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => false);
      });

      test('return offline error', () async {
        await authenticationRepositoryImpl.createUserEmailPassword(
            authData: tAuthUserReq);
        verify(mockNetworkInfo.hasConnection).called(1);
        verifyZeroInteractions(mockAuthFirebaseService);
      });
    });
  });

  group('Signin user with email and password', () {
    test('Checking for internet connection', () async {
      //arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      //act
      await authenticationRepositoryImpl.signInUserEmailPassword(
          authData: tAuthUserReq);
      //assert
      verify(mockNetworkInfo.hasConnection);
    });

    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      });

      test(
          'Should return user credential when user has been authenticated successfuly',
          () async {
        final tUsercred = MockUserCredential();
        //arrange
        when(mockAuthFirebaseService.signInUserEmailPassword(
                authData: tAuthUserReq))
            .thenAnswer((_) async => tUsercred);
        //act
        var result = await authenticationRepositoryImpl.signInUserEmailPassword(
            authData: tAuthUserReq);
        //assert
        verify(mockNetworkInfo.hasConnection).called(1);
        verify(mockAuthFirebaseService.signInUserEmailPassword(
                authData: tAuthUserReq))
            .called(1);
        expect(result, Right(tUsercred));
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });

      test('error Sigin throws exception', () async {
        when(mockAuthFirebaseService.signInUserEmailPassword(
                authData: tAuthUserReq))
            .thenThrow(Exception());

        var result = await authenticationRepositoryImpl.signInUserEmailPassword(
            authData: tAuthUserReq);

        expect(result, Left(OtherFailure(Exception().toString())));

        verify(mockAuthFirebaseService.signInUserEmailPassword(
                authData: tAuthUserReq))
            .called(1);
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => false);
      });

      test('return offline error', () async {
        await authenticationRepositoryImpl.createUserEmailPassword(
            authData: tAuthUserReq);
        verify(mockNetworkInfo.hasConnection).called(1);
        verifyZeroInteractions(mockAuthFirebaseService);
      });
    });
  });
  group('Google user with email and password', () {
    test('Checking for internet connection', () async {
      //arrange
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      //act
      await authenticationRepositoryImpl.googleSignIn();
      //assert
      verify(mockNetworkInfo.hasConnection);
    });

    group('Device is online', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
      });

      test(
          'Should return user credential when user has been authenticated successfuly',
          () async {
        final tUsercred = MockUserCredential();
        //arrange
        when(mockAuthFirebaseService.googleSignIn())
            .thenAnswer((_) async => tUsercred);
        //act
        var result = await authenticationRepositoryImpl.googleSignIn();
        //assert
        verify(mockNetworkInfo.hasConnection).called(1);
        verify(mockAuthFirebaseService.googleSignIn()).called(1);
        expect(result, Right(tUsercred));
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });

      test('error Sigin throws exception', () async {
        when(mockAuthFirebaseService.googleSignIn()).thenThrow(Exception());

        var result = await authenticationRepositoryImpl.googleSignIn();

        expect(result, Left(OtherFailure(Exception().toString())));

        verify(mockAuthFirebaseService.googleSignIn()).called(1);
        verifyNoMoreInteractions(mockAuthFirebaseService);
      });
    });

    group('Device is offline', () {
      setUp(() {
        when(mockNetworkInfo.hasConnection).thenAnswer((_) async => false);
      });

      test('return offline error', () async {
        await authenticationRepositoryImpl.googleSignIn();
        verify(mockNetworkInfo.hasConnection).called(1);
        verifyZeroInteractions(mockAuthFirebaseService);
      });
    });
  });

  group('check if user is logged in', () {
    setUp(() {
      when(mockNetworkInfo.hasConnection).thenAnswer((_) async => true);
    });
    test('user is logged in', () async {
      when(mockAuthFirebaseService.isLoggedIn()).thenAnswer((_) async => true);
      var loggedin = await authenticationRepositoryImpl.isLoggedIn();
      expect(loggedin, true);
    });
  });
}
