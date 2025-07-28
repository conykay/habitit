import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoService {
  Future<bool> get hasConnection;
}

class NetworkInfoServiceImpl implements NetworkInfoService {
  NetworkInfoServiceImpl();
  @override
  Future<bool> get hasConnection =>
      InternetConnectionChecker.instance.hasConnection;
}
