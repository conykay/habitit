import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/core/platform_info/platform_info.dart';

void main() {
  late PlatformInfoImpl platformInfoImpl;

  setUp(() {
    platformInfoImpl = PlatformInfoImpl();
  });
  test('checks platform is web', () {
    var isweb = platformInfoImpl.isWeb;
    expect(isweb, false);
  });
}
