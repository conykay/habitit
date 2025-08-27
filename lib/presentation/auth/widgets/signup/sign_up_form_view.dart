import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';
import 'package:habitit/common/button/widget/reactive_elevated_button.dart';
import 'package:habitit/core/helper/validator/auth_inputs_validator.dart';
import 'package:habitit/core/navigation/app_router.dart';
import 'package:habitit/domain/auth/entities/auth_user_req_entity.dart';
import 'package:habitit/domain/auth/usecases/create_user_email_password_usecase.dart';

import '../../../../domain/auth/usecases/signin_google.dart';
import '../../../../service_locator.dart';

class SignupFormView extends StatefulWidget {
  SignupFormView({super.key});

  @override
  State<SignupFormView> createState() => _SignupFormViewState();
}

class _SignupFormViewState extends State<SignupFormView> {
  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  final _nameTextController = TextEditingController();

  final _formState = GlobalKey<FormState>();

  late bool isVisible;

  @override
  void initState() {
    super.initState();
    isVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: _formState,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field cannot be empty mr.nobody :)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (!InputValidator.isEmailValid(value!)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordTextController,
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                  ),
                  validator: (value) {
                    if (!InputValidator.passwordValidator(value!) ||
                        value.isEmpty) {
                      return 'Password cannot be less than 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
              ],
            ),
            Column(
              children: [
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
                  title: 'Sign Up',
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
                    context.pushNamed(AppRoutes.signIn);
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
          ],
        ),
      ),
    );
  }
}
