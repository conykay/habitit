import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late MockInternetConnectionChecker internetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    internetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(internetConnectionChecker: internetConnectionChecker);
  });

  group('Connection available', () {
    setUp(() {
      when(internetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
    });
    test('Network info should return connection', () async {
      final result = await networkInfoImpl.hasConection;
      verify(internetConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
