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
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Points',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                Text.rich(
                    TextSpan(text: rewards.xp.toString(), children: [
                      TextSpan(text: 'xp', style: TextStyle(fontSize: 20))
                    ]),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.primary))
              ],
            )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Level',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                Text(rewards.level.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.primary))
              ],
            )),
          ],
        ));
  }
}
