part of 'quotes_cubit.dart';

@immutable
sealed class QuotesState {}

final class QuotesInitial extends QuotesState {}

final class QuotesLoading extends QuotesState {}

final class QuotesLoaded extends QuotesState {
  final List<QuotesEntity>? quotes;
  final QuotesEntity? quote;

  QuotesLoaded({this.quotes, this.quote});
}

final class QuotesError extends QuotesState {
  final String? error;

  QuotesError({this.error});
}
