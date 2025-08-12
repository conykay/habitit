import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/quotes/bloc/quotes_cubit.dart';

class SignUpTitleView extends StatelessWidget {
  const SignUpTitleView({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 60),
      child: Column(
        children: [
          Text(
            'Welcome To Habitit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<QuotesCubit, QuotesState>(
            builder: (context, state) {
              switch (state) {
                case QuotesLoaded():
                  return Column(
                    children: [
                      Text(state.quote!.quote,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18)),
                      Text('- ${state.quote!.author}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16)),
                    ],
                  );
                default:
                  return Text(
                    'Habits are the compound interest of self-improvement',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
