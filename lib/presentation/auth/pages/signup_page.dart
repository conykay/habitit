import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/common/button/widget/reactive_elevated_button.dart';
import 'package:habitit/core/error/failures.dart';
import 'package:habitit/core/navigation/app_navigator.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/auth/repository/authentication_repository_impl.dart';
import 'package:habitit/data/auth/sources/auth_firebase_service.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';
import 'package:habitit/domain/auth/usecases/signin_google.dart';
import 'package:habitit/presentation/auth/pages/signin_page.dart';
import 'package:habitit/presentation/home/pages/home_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationRepositoryImpl(
          firebaseService: AuthFirebaseServiceImpl(
              auth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance),
          networkInfo: NetworkInfoImpl(
              internetConnectionChecker: InternetConnectionChecker.instance)),
      child: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state.state == Buttonstate.loaded) {
              AppNavigator.pushReplacement(context, HomePage());
            }
            if (state.state == Buttonstate.failed) {
              OtherFailure failure = state.error;
              var snackbar = SnackBar(
                content: Text(failure.error.toString()),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          child: Scaffold(
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
          ),
        ),
      ),
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
  final _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        children: [
          SizedBox(height: 25),
          TextFormField(
            controller: _nameTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field cannot be empty mr.nobody :)';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailTextController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please provide a valid email';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 20),
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
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          SizedBox(height: 25),
          ReactiveElevatedButton(
            onPressed: () {
              if (_formState.currentState!.validate()) {
                context.read<ButtonStateCubit>().call(
                    usecase: CreateUserEmailPasswordUseCase(
                        context.read<AuthenticationRepositoryImpl>()),
                    params: AuthUserReqEntity(
                      email: _emailTextController.text,
                      password: _emailTextController.text,
                      name: _nameTextController.text,
                    ));
              }
            },
            title: 'Continue',
          ),
          SizedBox(height: 25),
          Divider(thickness: 1),
          SizedBox(height: 20),
          Builder(builder: (context) {
            return ReactiveElevatedButton(
              onPressed: () {
                context.read<ButtonStateCubit>().call(
                    usecase: SigninGoogleUseCase(
                        context.read<AuthenticationRepositoryImpl>()));
              },
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: 30,
                  ),
                  Text('oogle Sign In'),
                ],
              ),
            );
          }),
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
