import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

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
                  SignInWidget(),
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
          'Welcome Back',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Men\'s natures are alike, it is their habits that carry them far apart',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Log in to Continue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class SignInWidget extends StatelessWidget {
  SignInWidget({super.key});

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 25),
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
                Text('oogle Log In'),
              ],
            ),
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              AppNavigator.pushReplacement(context, SignupPage());
            },
            child: Text.rich(TextSpan(
                text: 'New to change ?',
                style: TextStyle(fontSize: 18),
                children: [
                  TextSpan(
                    text: ' Sign Up',
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
