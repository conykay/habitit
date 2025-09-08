import 'package:bloc/bloc.dart';
import 'package:habitit/domain/quotes/entities/quotes_entity.dart';
import 'package:habitit/domain/quotes/usecases/get_all_quotes_usecase.dart';
import 'package:meta/meta.dart';

import '../../../domain/quotes/usecases/get_quote_usecase.dart';
import '../../../service_locator.dart';

part 'quotes_state.dart';

class QuotesCubit extends Cubit<QuotesState> {
  QuotesCubit() : super(QuotesInitial()) {
    _getQuote();
  }

  void _getQuotes() async {
    await sl.get<GetAllQuotesUseCase>().call();
  }

  void _getQuote() async {
    emit(QuotesLoading());
    var quote = await sl.get<GetQuoteUseCase>().call();
    quote.fold(
      (e) => emit(QuotesError(error: e)),
      (data) => emit(QuotesLoaded(quote: data)),
    );
  }
}
