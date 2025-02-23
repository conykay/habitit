// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';

import '../repository/rewards_repository.dart';

class GetUserRewardsUsecase extends UseCase<Either, dynamic> {
  final RewardsRepository repository;
  GetUserRewardsUsecase({
    required this.repository,
  });

  @override
  Future<Either> call({params}) async {
    return await repository.getUserRewards();
  }
}
