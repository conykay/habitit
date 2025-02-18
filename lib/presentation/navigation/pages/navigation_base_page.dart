import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/navigation/navigation_state.dart';
import 'package:habitit/common/navigation/navigation_state_cubit.dart';
import 'package:habitit/core/navigation/navigation.dart';

class NavigationBasePage extends StatelessWidget {
  const NavigationBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationStateCubit(),
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Center(
              child: Text('Huge layout booooy'),
            ),
          );
        } else {
          return _smallDeviceLayout();
        }
      }),
    );
  }

  Scaffold _smallDeviceLayout() {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: BlocBuilder<NavigationStateCubit, NavigationState>(
              builder: (context, state) {
            var title = navData[state.index].appBarTitle;
            return AppBar(
              title: Text(title),
              actions: [
                IconButton(
                    onPressed: () {}, icon: FaIcon(FontAwesomeIcons.bell))
              ],
            );
          })),
      body: Center(
        child: Text('Tiny Tina Trashhh'),
      ),
      bottomNavigationBar: BlocBuilder<NavigationStateCubit, NavigationState>(
          builder: (context, state) {
        return NavigationBar(
          selectedIndex: state.index,
          destinations: navData
              .map((e) => NavigationDestination(
                    icon: FaIcon(
                      e.icon,
                      color: Colors.grey,
                    ),
                    label: e.label,
                    selectedIcon: FaIcon(
                      e.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ))
              .toList(),
          onDestinationSelected: (index) {},
        );
      }),
    );
  }
}
