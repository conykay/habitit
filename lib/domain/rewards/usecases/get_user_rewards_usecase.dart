// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../repository/rewards_repository.dart';

class GetUserRewardsUseCase {
  GetUserRewardsUseCase({required RewardsRepository rewardsRepository})
      : _rewardsRepository = rewardsRepository;
  final RewardsRepository _rewardsRepository;
  Stream<Either> call({params}) {
    return _rewardsRepository.getUserRewards();
  }
}
