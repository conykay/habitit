// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../service_locator.dart';
import '../repository/rewards_repository.dart';

class GetUserRewardsUseCase {
  Stream<Either> call({params}) {
    return sl.get<RewardsRepository>().getUserRewards();
  }
}
