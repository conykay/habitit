// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repository/rewards_repository.dart';

class GetUserRewardsUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl.get<RewardsRepository>().getUserRewards();
  }
}
