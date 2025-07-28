// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

import '../../../service_locator.dart';

class AddUserXpUseCase extends UseCase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl
        .get<RewardsRepository>()
        .updateUserRewards(xpAmount: params!);
  }
}
