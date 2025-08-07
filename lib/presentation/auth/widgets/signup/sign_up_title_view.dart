import 'package:flutter/material.dart';

class SignUpTitleView extends StatelessWidget {
  const SignUpTitleView({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 60),
      child: Column(
        children: [
          Text(
            'Welcome To Habitit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Habits are the compound interest of self-improvement',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
