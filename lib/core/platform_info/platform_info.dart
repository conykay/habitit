import 'package:flutter/foundation.dart';

abstract class PlatformInfoService {
  bool get isWeb;
}

class PlatformInfoImpl extends PlatformInfoService {
  @override
  bool get isWeb => kIsWeb;
}
