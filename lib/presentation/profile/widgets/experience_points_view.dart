import 'package:flutter/material.dart';

import '../../../domain/rewards/entities/user_reward_entity.dart';

class ExperiencePointsView extends StatelessWidget {
  const ExperiencePointsView({
    super.key,
    required this.rewards,
  });

  final UserRewardEntity rewards;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green.withValues(alpha: 0.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Points',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green)),
              Text.rich(
                  TextSpan(text: rewards.xp.toString(), children: [
                    TextSpan(text: 'xp', style: TextStyle(fontSize: 20))
                  ]),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.green))
            ],
          ),
        )),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueAccent.withValues(alpha: 0.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Level',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueAccent)),
              Text(rewards.level.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.blueAccent))
            ],
          ),
        )),
      ],
    );
  }
}
