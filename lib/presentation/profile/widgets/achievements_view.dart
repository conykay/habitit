import 'package:flutter/material.dart';

import '../../../common/rewards/reward_badges.dart';
import 'badge.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({
    super.key,
    required this.badgesEarned,
  });

  final List<String> badgesEarned;

  @override
  Widget build(BuildContext context) {
    var userBadge =
        badges.where((badge) => badgesEarned.contains(badge.id)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: badgesEarned.isEmpty
              ? Center(
                  child: Text(
                      'You haven\'t earned any badges,create your first habit to start.'),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return AchievementBadge(
                      colors: userBadge[index].colors,
                      icon: userBadge[index].icon,
                      name: userBadge[index].name,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: userBadge.length),
        ),
      ],
    );
  }
}
