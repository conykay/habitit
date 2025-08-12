import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repository/quotes.dart';

class GetQuoteUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) {
    return sl.get<QuotesRepository>().getQuote();
  }
}
