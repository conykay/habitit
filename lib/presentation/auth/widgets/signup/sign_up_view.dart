import 'package:flutter/material.dart';
import 'package:habitit/presentation/auth/widgets/signup/sign_up_form_view.dart';
import 'package:habitit/presentation/auth/widgets/signup/sign_up_title_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows resizing when keyboard appears
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
                  SignUpTitleView(context: context),
                  SignupFormView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
