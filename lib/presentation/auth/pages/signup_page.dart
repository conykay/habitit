import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/auth/auth_state_cubit.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/common/button/widget/reactive_elevated_button.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';

import '../../../service_locator.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state.state == ButtonStates.loaded) {
/*
            AppNavigator.pushAndRemove(context, NavigationBasePage());

*/
            BlocProvider.of<AuthStateCubit>(context).isAuthenticated();
          }
          if (state.state == ButtonStates.failed) {
            OtherFailure failure = state.error;
            var snackbar = SnackBar(
              content: Text(failure.error.toString()),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset:
              true, // Allows resizing when keyboard appears
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600, // Limit width for better web design
                  ),
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
                        child: SignupView(),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome To Habitit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
            color: Theme.of(context).canvasColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Habits are the compound interest of self-improvement',
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

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Signup & Get Started',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty mr.nobody :)';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please provide a valid email';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please provide a valid password';
              }
              if (value.length < 6) {
                return 'Password cannot be less than six characters';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          const SizedBox(height: 25),
          ReactiveElevatedButton(
            onPressed: () {
              if (_formState.currentState!.validate()) {
                context.read<ButtonStateCubit>().call(
                    usecase: sl.get<CreateUserEmailPasswordUseCase>(),
                    params: AuthUserReqEntity(
                      email: _emailTextController.text,
                      password: _emailTextController.text,
                      name: _nameTextController.text,
                    ));
              }
            },
            title: 'Continue',
          ),
          const SizedBox(height: 25),
          const Divider(thickness: 1),
          const SizedBox(height: 20),
          Builder(builder: (context) {
            return ReactiveElevatedButton(
              onPressed: () {
                context.read<ButtonStateCubit>().call(
                      usecase: sl.get<SignInGoogleUseCase>(),
                    );
              },
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: 30,
                  ),
                  Text('oogle Sign In'),
                ],
              ),
            );
          }),
          const SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              AppNavigator.pushReplacement(context, SignInPage());
            },
            child: Text.rich(TextSpan(
                text: 'Already have an account ?',
                style: const TextStyle(fontSize: 18),
                children: [
                  TextSpan(
                    text: ' Log in',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ])),
          ),
        ],
      ),
    );
  }
}
