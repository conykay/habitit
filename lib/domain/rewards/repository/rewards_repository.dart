import 'package:dartz/dartz.dart';

abstract class RewardsRepository {
  Future<Either> updateUserRewards({required int xpAmount});

  Stream<Either> getUserRewards();
}
