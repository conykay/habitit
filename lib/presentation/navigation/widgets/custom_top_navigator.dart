import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/navigation/navigation_state_cubit.dart';
import '../../../core/navigation/navigation.dart';

class CustomTopNavigator extends StatelessWidget {
  final int index;
  final NavigationData navdata;
  const CustomTopNavigator({
    super.key,
    required this.index,
    required this.navdata,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = navData.indexOf(navdata) == index;

    return GestureDetector(
      onTap: () {
        BlocProvider.of<NavigationStateCubit>(context)
            .getNavBarItem(NavItem.values[navData.indexOf(navdata)]);
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                isFocused ? Theme.of(context).focusColor : Colors.transparent),
        padding: EdgeInsets.all(10),
        child: Text(
          navdata.label,
          style: TextStyle(
              fontSize: 18,
              fontWeight: isFocused ? FontWeight.bold : FontWeight.w100,
              color: isFocused
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
