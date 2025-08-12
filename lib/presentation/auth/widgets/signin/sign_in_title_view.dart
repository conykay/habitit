import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/common/quotes/bloc/quotes_cubit.dart';

class SignInTitleView extends StatelessWidget {
  const SignInTitleView({
    super.key,
    required this.context,
  });

  final BuildContext context;

//todo: Incorporate dynamic quotes from API (Home Page too ?)
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 60),
      child: Column(
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 15),
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
                    "Men's natures are alike, it is their habits that carry them far apart",
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
