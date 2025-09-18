import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchievementBadge extends StatelessWidget {
  final List<Color> colors;
  final IconData icon;
  final String name;
  const AchievementBadge({
    super.key,
    required this.colors,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(colors: colors),
              border: Border.all(color: Colors.yellow, width: 5)),
          child: Center(
              child: FaIcon(
            icon,
            size: 15,
            color: Colors.white70,
          )),
        ),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        )
      ],
    );
  }
}
