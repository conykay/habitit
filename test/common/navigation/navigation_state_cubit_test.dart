import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/common/navigation/navigation_state.dart';
import 'package:habitit/common/navigation/navigation_state_cubit.dart';
import 'package:habitit/core/navigation/navigation.dart';

void main() {
  group('navigation cubit test', () {
    blocTest(
      'returns navition state',
      build: () => NavigationStateCubit(),
      act: (bloc) => bloc.getNavBarItem(NavItem.habits),
      expect: () => [NavigationState(navItem: NavItem.habits, index: 1)],
    );
  });
}
