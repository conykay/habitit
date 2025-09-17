import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/core/platform_info/platform_info.dart';
import 'package:habitit/core/theme/repository/theme_repository.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/data/habits/repository/habits_repository_impl.dart';
import 'package:habitit/data/habits/source/habits_firebase_service.dart';
import 'package:habitit/data/habits/source/habits_hive_service.dart';
import 'package:habitit/data/notifications/source/notifications_hive_service.dart';
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
import 'data/notifications/source/notification_service.dart';
import 'data/quotes/source/quotes_hive_service.dart';
import 'data/rewards/repository/rewards_repository.dart';
import 'domain/auth/repository/authentication_repository.dart';
import 'domain/quotes/usecases/get_quote_usecase.dart';
import 'domain/rewards/repository/rewards_repository.dart';

final sl = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  //SERVICES
  //firebase
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn.standard());
  //core
  sl.registerSingleton<PlatformInfoService>(PlatformInfoImpl());
  sl.registerSingleton<NetworkInfoService>(NetworkInfoServiceImpl());
  //Notifications
  sl.registerFactoryAsync<NotificationHiveService>(() async {
    final service = await NotificationHiveServiceImpl.getInstance(
        auth: sl.get<FirebaseAuth>());
    return service;
  });
  sl.registerLazySingletonAsync<NotificationService>(() async =>
      NotificationServiceImpl(
        messagingInstance: sl.get<FirebaseMessaging>(),
        notificationHiveService: await sl.getAsync<NotificationHiveService>(),
      ));
  //Auth
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl(
    auth: sl.get<FirebaseAuth>(),
    firestore: sl.get<FirebaseFirestore>(),
    googleSignIn: sl<GoogleSignIn>(),
  ));
  //Habit Module
  sl.registerSingleton<HabitsFirebaseService>(HabitsFirebaseServiceImpl(
    firestore: sl.get<FirebaseFirestore>(),
    auth: sl.get<FirebaseAuth>(),
  ));
  //Async
  sl.registerFactoryAsync<HabitsHiveService>(() async {
    final service =
        await HabitsHiveServiceImpl.getInstance(auth: sl.get<FirebaseAuth>());
    return service;
  });
  //Rewards Module
  sl.registerLazySingletonAsync<RewardsFirebaseService>(
      () async => RewardsFirebaseServiceImpl(
            firebaseAuth: sl.get<FirebaseAuth>(),
            firestore: sl.get<FirebaseFirestore>(),
            notificationService: await sl.getAsync<NotificationService>(),
          ));
  //Async
  sl.registerFactoryAsync<RewardsHiveService>(() async {
    final service =
        await RewardsHiveServiceImpl.getInstance(auth: sl.get<FirebaseAuth>());
    return service;
  });
  //quotes
  sl.registerSingleton<QuotesApiService>(QuotesApiServiceImpl());
  sl.registerSingleton<QuotesHiveService>(QuotesHiveServiceImpl());
  // REPOSITORIES
  //core
  sl.registerSingleton<ThemeRepository>(ThemeRepository());
  //Auth
  sl.registerSingleton<AuthenticationRepository>(AuthenticationRepositoryImpl(
    authFirebaseService: sl.get<AuthFirebaseService>(),
    networkInfoService: sl.get<NetworkInfoService>(),
  ));
  //Habits
  sl.registerLazySingletonAsync<HabitsRepository>(
      () async => HabitsRepositoryImpl(
            networkInfoService: sl.get<NetworkInfoService>(),
            firebaseService: sl.get<HabitsFirebaseService>(),
            hiveService: await sl.getAsync<HabitsHiveService>(),
          ));
  //Rewards
  sl.registerLazySingletonAsync<RewardsRepository>(
      () async => RewardsRepositoryImpl(
            rewardsFirebaseService: await sl.getAsync<RewardsFirebaseService>(),
            rewardsHiveService: await sl.getAsync<RewardsHiveService>(),
            networkInfoService: sl.get<NetworkInfoService>(),
          ));
  //quotes
  sl.registerSingleton<QuotesRepository>(QuotesRepositoryImp());

  //USECASES
  //auth
  sl.registerSingleton<UserLoggedInUseCase>(UserLoggedInUseCase(
      authenticationRepository: sl.get<AuthenticationRepository>()));
  sl.registerLazySingleton<CreateUserEmailPasswordUseCase>(() =>
      CreateUserEmailPasswordUseCase(
          authenticationRepository: sl.get<AuthenticationRepository>()));
  sl.registerLazySingleton<LogoutUserUseCase>(() => LogoutUserUseCase(
      authenticationRepository: sl.get<AuthenticationRepository>()));
  sl.registerLazySingleton<SignInEmailPasswordUseCase>(() =>
      SignInEmailPasswordUseCase(
          authenticationRepository: sl.get<AuthenticationRepository>()));
  sl.registerLazySingleton<SignInGoogleUseCase>(() => SignInGoogleUseCase(
      authenticationRepository: sl.get<AuthenticationRepository>()));
  //HabitModule
  sl.registerLazySingletonAsync<GetAllHabitsUseCase>(() async =>
      GetAllHabitsUseCase(
          habitsRepository: await sl.getAsync<HabitsRepository>()));
  sl.registerLazySingletonAsync<GetHabitUseCase>(() async =>
      GetHabitUseCase(habitsRepository: await sl.getAsync<HabitsRepository>()));
  sl.registerLazySingletonAsync<AddHabitUseCase>(() async =>
      AddHabitUseCase(habitsRepository: await sl.getAsync<HabitsRepository>()));
  sl.registerLazySingletonAsync<EditHabitUseCase>(() async => EditHabitUseCase(
      habitsRepository: await sl.getAsync<HabitsRepository>()));
  sl.registerLazySingletonAsync<DeleteHabitUseCase>(() async =>
      DeleteHabitUseCase(
          habitsRepository: await sl.getAsync<HabitsRepository>()));
  //RewardModule
  sl.registerLazySingletonAsync<GetUserRewardsUseCase>(() async =>
      GetUserRewardsUseCase(
          rewardsRepository: await sl.getAsync<RewardsRepository>()));
  sl.registerLazySingletonAsync<AddUserXpUseCase>(() async => AddUserXpUseCase(
      rewardsRepository: await sl.getAsync<RewardsRepository>()));
  //quotesModule
  sl.registerSingleton<GetAllQuotesUseCase>(GetAllQuotesUseCase());
  sl.registerSingleton<GetQuoteUseCase>(GetQuoteUseCase());
}

// re-initialize service
Future<void> reinitializeLocator() async {
  if (sl.isRegistered<RewardsHiveService>() &&
      sl.isRegistered<HabitsHiveService>() &&
      sl.isRegistered<NotificationHiveService>()) {
    try {
      final oldRewardService = await sl.getAsync<RewardsHiveService>();
      final oldHabitsService = await sl.getAsync<HabitsHiveService>();
      final oldNotificationService =
          await sl.getAsync<NotificationHiveService>();

      oldHabitsService.close();
      oldRewardService.close();
      oldNotificationService.close();
    } catch (e) {
      print('Error closing old services: ${e.toString()}');
    }
    sl.unregister<RewardsHiveService>();
    sl.unregister<HabitsHiveService>();
    sl.unregister<NotificationHiveService>();
  }
  sl.registerFactoryAsync<RewardsHiveService>(() async {
    final service =
        await RewardsHiveServiceImpl.getInstance(auth: sl.get<FirebaseAuth>());
    return service;
  });
  sl.registerFactoryAsync<HabitsHiveService>(() async {
    final service =
        await HabitsHiveServiceImpl.getInstance(auth: sl.get<FirebaseAuth>());
    return service;
  });
  sl.registerFactoryAsync<NotificationHiveService>(() async {
    final service = await NotificationHiveServiceImpl.getInstance(
        auth: sl.get<FirebaseAuth>());
    return service;
  });
}
