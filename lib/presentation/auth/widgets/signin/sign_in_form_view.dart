import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/common/button/widget/reactive_elevated_button.dart';
import 'package:habitit/core/navigation/app_router.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/signin_email_password.dart';

import '../../../../domain/auth/usecases/signin_google.dart';
import '../../../../service_locator.dart';

class SignInFormView extends StatelessWidget {
  SignInFormView({super.key});

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
//todo: (add email and password validators), (password visibility toggle)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
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
                ],
              ),
            ),
            Column(
              children: [
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
                  title: 'Log In',
                ),
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
                      FaIcon(
                        FontAwesomeIcons.google,
                        size: 35,
                        color: Colors.blueAccent,
                      ),
                      Text(
                        'oogle Account',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(AppRoutes.signUp);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account ?',
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
          ],
        ),
      ),
    );
  }
}
