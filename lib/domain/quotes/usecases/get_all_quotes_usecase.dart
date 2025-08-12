import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/quotes/repository/quotes.dart';

import '../../../service_locator.dart';

class GetAllQuotesUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl.get<QuotesRepository>().getQuotes();
  }
}
