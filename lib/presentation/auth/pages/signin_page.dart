import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/common/button/widget/reactive_elevated_button.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';
import 'package:habitit/presentation/auth/pages/signup_page.dart';
import 'package:habitit/presentation/navigation/pages/navigation_base_page.dart';

import '../../../domain/auth/usecases/signin_google.dart';
import '../../../service_locator.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state.state == Buttonstate.loaded) {
            AppNavigator.pushAndRemove(context, NavigationBasePage());
          }
          if (state.state == Buttonstate.failed) {
            var snackBar = SnackBar(
              content: Text(state.error.toString()),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 60),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: _buildIntro(context),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: SignInWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Theme.of(context).canvasColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Men's natures are alike, it is their habits that carry them far apart",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ],
    );
  }
}

class SignInWidget extends StatelessWidget {
  SignInWidget({super.key});

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Log In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            controller: _emailTextController,
            validator: (value) =>
                value!.isEmpty ? 'This field cannot be empty' : null,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordTextController,
            validator: (value) =>
                value!.isEmpty ? 'Password cannot be empty' : null,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const SizedBox(height: 25),
          ReactiveElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ButtonStateCubit>().call(
                    usecase: sl.get<SignInEmailPasswordUseCase>(),
                    params: AuthUserReqEntity(
                      email: _emailTextController.text,
                      password: _emailTextController.text,
                    ));
              }
            },
            title: 'Continue',
          ),
          const SizedBox(height: 25),
          const Divider(thickness: 1),
          const SizedBox(height: 20),
          ReactiveElevatedButton(
            onPressed: () {
              context.read<ButtonStateCubit>().call(
                    usecase: sl.get<SignInGoogleUseCase>(),
                  );
            },
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(FontAwesomeIcons.google, size: 30),
                Text('oogle Log In'),
              ],
            ),
          ),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              AppNavigator.pushReplacement(context, SignupPage());
            },
            child: Text.rich(
              TextSpan(
                text: 'New to change?',
                style: const TextStyle(fontSize: 18),
                children: [
                  TextSpan(
                    text: ' Sign Up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
