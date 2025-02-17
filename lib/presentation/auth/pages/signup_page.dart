import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width > 600 ? 400 : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIntro(context),
                  SignupWidget(),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome To Habitit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Habits are the compound interest of self-improvement',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Signup & Get Started',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class SignupWidget extends StatelessWidget {
  SignupWidget({super.key});

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 25),
          TextFormField(
            controller: _nameTextController,
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailTextController,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordTextController,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            child: Text('Continue'),
          ),
          SizedBox(height: 25),
          Divider(thickness: 1),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.google,
                  size: 30,
                ),
                Text('oogle Sign In'),
              ],
            ),
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, SigninPage());
            },
            child: Text.rich(TextSpan(
                text: 'Already have an account ?',
                style: TextStyle(fontSize: 18),
                children: [
                  TextSpan(
                    text: ' Log in',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ])),
          )
        ],
      ),
    );
  }
}
