// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';

class AddUserXpUsecase extends UseCase<Either, int> {
  final RewardsRepository repository;
  AddUserXpUsecase({
    required this.repository,
  });
  @override
  Future<Either> call({int? params}) async {
    return await repository.updateUserRewards(xpAmmount: params!);
  }
}
