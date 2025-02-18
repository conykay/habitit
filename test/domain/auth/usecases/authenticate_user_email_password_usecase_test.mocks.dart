// Mocks generated by Mockito 5.4.5 from annotations
// in habitit/test/domain/auth/usecases/authenticate_user_email_password_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:habitit/core/error/failures.dart' as _i5;
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart' as _i7;
import 'package:habitit/domain/auth/repository/authentication_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthenticationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationRepository extends _i1.Mock
    implements _i3.AuthenticationRepository {
  MockAuthenticationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>
  createUserEmailPassword({required _i7.AuthUserReqEntity? authData}) =>
      (super.noSuchMethod(
            Invocation.method(#createUserEmailPassword, [], {
              #authData: authData,
            }),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>.value(
                  _FakeEither_0<_i5.Failures, _i6.UserCredential>(
                    this,
                    Invocation.method(#createUserEmailPassword, [], {
                      #authData: authData,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>);

  @override
  _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>
  signinUserEmailPassword({required _i7.AuthUserReqEntity? authData}) =>
      (super.noSuchMethod(
            Invocation.method(#signinUserEmailPassword, [], {
              #authData: authData,
            }),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>.value(
                  _FakeEither_0<_i5.Failures, _i6.UserCredential>(
                    this,
                    Invocation.method(#signinUserEmailPassword, [], {
                      #authData: authData,
                    }),
                  ),
                ),
          )
          as _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>);

  @override
  _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>> googleSignin() =>
      (super.noSuchMethod(
            Invocation.method(#googleSignin, []),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>.value(
                  _FakeEither_0<_i5.Failures, _i6.UserCredential>(
                    this,
                    Invocation.method(#googleSignin, []),
                  ),
                ),
          )
          as _i4.Future<_i2.Either<_i5.Failures, _i6.UserCredential>>);

  @override
  _i4.Future<_i2.Either<_i5.Failures, dynamic>> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i4.Future<_i2.Either<_i5.Failures, dynamic>>.value(
              _FakeEither_0<_i5.Failures, dynamic>(
                this,
                Invocation.method(#logout, []),
              ),
            ),
          )
          as _i4.Future<_i2.Either<_i5.Failures, dynamic>>);

  @override
  _i4.Future<bool> isLoggedIn() =>
      (super.noSuchMethod(
            Invocation.method(#isLoggedIn, []),
            returnValue: _i4.Future<bool>.value(false),
          )
          as _i4.Future<bool>);
}
