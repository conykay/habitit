// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/button/bloc/button_state.dart';
import 'package:habitit/common/button/bloc/button_state_cubit.dart';

class ReactiveElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Widget? content;
  const ReactiveElevatedButton({
    super.key,
    required this.onPressed,
    this.title = '',
    this.height,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state.state == Buttonstate.loading) {
          _loading();
        }

        if (state.state == Buttonstate.loaded) {
          _loaded();
        }

        return _inital();
      },
    );
  }

  Widget _inital() {
    return ElevatedButton(onPressed: onPressed, child: content ?? Text(title));
  }

  Widget _loading() {
    return ElevatedButton(
      onPressed: null,
      child: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loaded() {
    return ElevatedButton(
      onPressed: null,
      child: Container(
        alignment: Alignment.center,
        child: Icon(Icons.check),
      ),
    );
  }
}
