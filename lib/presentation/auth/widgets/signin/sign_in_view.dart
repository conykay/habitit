import 'package:flutter/material.dart';
import 'package:habitit/presentation/auth/widgets/signin/sign_in_form_view.dart';
import 'package:habitit/presentation/auth/widgets/signin/sign_in_title_view.dart';

class SignInView extends StatelessWidget {
  const SignInView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  SignInTitleView(context: context),
                  SignInFormView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
