import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/repository/authentication_repository.dart';
import 'package:habitit/domain/auth/usecases/authenticate_user_email_password_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthenticationRepository])
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticateUserEmailPasswordUseCase usecase;
  late MockAuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = AuthenticateUserEmailPasswordUseCase(repository);
  });

  final tAuthUserReq =
      AuthUserReqEntity(email: 'test@test.com', password: 'testPass');

  final tSuccessMessage = 'Authentication passed';

  test('Should pass user authentication request', () async* {
    when(repository.authUserEmailPassword(authData: tAuthUserReq))
        .thenAnswer((_) {
      return Future.value(Right(tSuccessMessage)); // Explicit return is KEY!
    });

    var result = usecase.call(params: tAuthUserReq);

    expect(result, Right(tSuccessMessage));

    verify(repository.authUserEmailPassword(authData: tAuthUserReq));
    verifyNoMoreInteractions(repository);
  });
}
