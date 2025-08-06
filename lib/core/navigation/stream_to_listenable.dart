import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';

class StreamToListenable extends ChangeNotifier {
  late final StreamSubscription subscription;

  StreamToListenable(AuthStateCubit cubit) {
    subscription =
        cubit.stream.asBroadcastStream().listen((event) => notifyListeners());
    notifyListeners();
  }
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
