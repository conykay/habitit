import 'package:flutter/foundation.dart';

abstract class PlatformInfo {
  bool get isWeb;
}

class PlatformInfoImpl extends PlatformInfo {
  PlatformInfoImpl();
  @override
  bool get isWeb => kIsWeb;
}
