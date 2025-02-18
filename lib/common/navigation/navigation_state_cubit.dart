import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/navigation/navigation_state.dart';
import 'package:habitit/core/navigation/navigation.dart';

class NavigationStateCubit extends Cubit<NavigationState> {
  NavigationStateCubit()
      : super(NavigationState(navItem: NavItem.home, index: 0));
  void getNavBarItem(NavItem navitem) {
    switch (navitem) {
      case NavItem.home:
        emit(NavigationState(navItem: NavItem.home, index: 0));
        break;
      case NavItem.habits:
        emit(NavigationState(navItem: NavItem.habits, index: 1));
        break;
      case NavItem.analytics:
        emit(NavigationState(navItem: NavItem.analytics, index: 2));
        break;
      case NavItem.profile:
        emit(NavigationState(navItem: NavItem.profile, index: 3));
        break;
    }
  }
}
