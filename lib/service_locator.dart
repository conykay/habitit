import 'package:get_it/get_it.dart';
import 'package:habitit/core/theme/repository/theme_repository.dart';

final sl = GetIt.instance;

Future<void> initializeGetItDependencies() async {
  // REPOSITORIES
  //Theme
  sl.registerSingleton<ThemeRepository>(ThemeRepository());
}
