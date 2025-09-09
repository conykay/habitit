import 'package:bloc/bloc.dart';
import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:meta/meta.dart';

import '../../../domain/quotes/usecases/get_quote_usecase.dart';
import '../../../service_locator.dart';

part 'quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  QuotesCubit() : super(QuotesInitial()) {
    fetchQuote();
  }

  void fetchQuote() async {
    emit(QuotesLoading());
    try {
      var eitherQuote = await sl.get<GetQuoteUseCase>().call();

      eitherQuote.fold(
        (e) => emit(QuotesError(error: e)),
        (data) => emit(QuotesLoaded(quote: data)),
      );
    } catch (e) {
      emit(QuotesError(error: e.toString()));
    }
  }
}
