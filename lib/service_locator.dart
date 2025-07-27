import 'package:get_it/get_it.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/core/platform_info/platform_info.dart';
import 'package:habitit/core/theme/repository/theme_repository.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/logout_user.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';

import 'data/auth/repository/authentication_repository_impl.dart';
import 'domain/auth/repository/authentication_repository.dart';

final sl = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  // REPOSITORIES
  //core
  sl.registerSingleton<ThemeRepository>(ThemeRepository());
  //Auth
  sl.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl());
  //SERVICES
  //core
  sl.registerSingleton<PlatformInfoService>(PlatformInfoImpl());
  sl.registerSingleton<NetworkInfoService>(NetworkInfoServiceImpl());
  //Auth
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  //USECASES
  //auth
  sl.registerSingleton<UserLoggedInUseCase>(UserLoggedInUseCase());
  sl.registerLazySingleton<CreateUserEmailPasswordUseCase>(
      () => CreateUserEmailPasswordUseCase());
  sl.registerLazySingleton<LogoutUserUseCase>(() => LogoutUserUseCase());
  sl.registerLazySingleton<SignInEmailPasswordUseCase>(
      () => SignInEmailPasswordUseCase());
  sl.registerLazySingleton<SignInGoogleUseCase>(() => SignInGoogleUseCase());
}
