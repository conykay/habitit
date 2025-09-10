import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/auth/auth_state_cubit.dart';
import '../../../core/theme/bloc/theme_cubit.dart';
import '../bloc/user_rewards_cubit.dart';
import '../bloc/user_rewards_state.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferences',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Brightness', style: TextStyle(fontSize: 20)),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return Switch(
                      value: state.themeMode == ThemeMode.dark,
                      onChanged: (_) async =>
                          context.read<ThemeCubit>().switchTheme());
                },
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        BlocBuilder<UserRewardsCubit, UserRewardsState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if (state is UserRewardsLoaded) {
                  context.read<AuthStateCubit>().logout();
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Log Out',
                        style: TextStyle(fontSize: 20, color: Colors.red)),
                    FaIcon(FontAwesomeIcons.doorOpen, color: Colors.red)
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
