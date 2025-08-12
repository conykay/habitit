import 'package:get_it/get_it.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/core/platform_info/platform_info.dart';
import 'package:habitit/core/theme/repository/theme_repository.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/data/habits/repository/habits_repository_impl.dart';
import 'package:habitit/data/habits/source/habits_firebase_service.dart';
import 'package:habitit/data/habits/source/habits_hive_service.dart';
import 'package:habitit/data/quotes/repository/quotes_repository.dart';
import 'package:habitit/data/quotes/source/quotes_api_service.dart';
import 'package:habitit/data/rewards/sources/rewards_firebase_service.dart';
import 'package:habitit/data/rewards/sources/rewards_hive_service.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/logout_user.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:habitit/domain/auth/usecases/user_logged_in.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/habits/usecases/add_habit_usecase.dart';
import 'package:habitit/domain/habits/usecases/delete_habit_usecase.dart';
import 'package:habitit/domain/habits/usecases/edit_habit_usecase.dart';
import 'package:habitit/domain/habits/usecases/get_all_habits_usecase.dart';
import 'package:habitit/domain/habits/usecases/get_habit_usecase.dart';
import 'package:habitit/domain/quotes/repository/quotes.dart';
import 'package:habitit/domain/quotes/usecases/get_all_quotes_usecase.dart';
import 'package:habitit/domain/rewards/usecases/add_user_xp_usecase.dart';
import 'package:habitit/domain/rewards/usecases/get_user_rewards_usecase.dart';

import 'data/auth/repository/authentication_repository_impl.dart';
import 'data/notifications/source/firebase_messaging_service.dart';
import 'data/rewards/repository/rewards_repository.dart';
import 'domain/auth/repository/authentication_repository.dart';
import 'domain/quotes/usecases/get_quote_usecase.dart';
import 'domain/rewards/repository/rewards_repository.dart';

final sl = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  // REPOSITORIES
  //core
  sl.registerSingleton<ThemeRepository>(ThemeRepository());
  //Auth
  sl.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl());
  //Habits
  sl.registerSingleton<HabitsRepository>(HabitsRepositoryImpl());
  //Rewards
  sl.registerSingleton<RewardsRepository>(RewardsRepositoryImpl());
  //quotes
  sl.registerSingleton<QuotesRepository>(QuotesRepositoryImp());
  //SERVICES
  //core
  sl.registerSingleton<PlatformInfoService>(PlatformInfoImpl());
  sl.registerSingleton<NetworkInfoService>(NetworkInfoServiceImpl());
  //Notifications
  sl.registerSingleton<NotificationService>(NotificationServiceImpl());
  //Auth
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  //Habit Module
  sl.registerSingleton<HabitsFirebaseService>(HabitsFirebaseServiceImpl());
  sl.registerSingleton<HabitsHiveService>(HabitsHiveServiceImpl());
  //Rewards Module
  sl.registerSingleton<RewardsHiveService>(RewardsHiveServiceImpl());
  sl.registerSingleton<RewardsFirebaseService>(RewardsFirebaseServiceImpl());
  //quotes
  sl.registerSingleton<QuotesApiService>(QuotesApiServiceImpl());
  //USECASES
  //auth
  sl.registerSingleton<UserLoggedInUseCase>(UserLoggedInUseCase());
  sl.registerLazySingleton<CreateUserEmailPasswordUseCase>(
      () => CreateUserEmailPasswordUseCase());
  sl.registerLazySingleton<LogoutUserUseCase>(() => LogoutUserUseCase());
  sl.registerLazySingleton<SignInEmailPasswordUseCase>(
      () => SignInEmailPasswordUseCase());
  sl.registerLazySingleton<SignInGoogleUseCase>(() => SignInGoogleUseCase());
  //HabitModule
  sl.registerLazySingleton<GetAllHabitsUseCase>(() => GetAllHabitsUseCase());
  sl.registerLazySingleton<GetHabitUseCase>(() => GetHabitUseCase());
  sl.registerLazySingleton<AddHabitUseCase>(() => AddHabitUseCase());
  sl.registerLazySingleton<EditHabitUseCase>(() => EditHabitUseCase());
  sl.registerLazySingleton<DeleteHabitUseCase>(() => DeleteHabitUseCase());
  //RewardModule
  sl.registerLazySingleton<GetUserRewardsUseCase>(
      () => GetUserRewardsUseCase());
  sl.registerLazySingleton<AddUserXpUseCase>(() => AddUserXpUseCase());
  //quotesModule
  sl.registerSingleton<GetAllQuotesUseCase>(GetAllQuotesUseCase());
  sl.registerSingleton<GetQuoteUseCase>(GetQuoteUseCase());
}
