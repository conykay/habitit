// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:habitit/domain/rewards/usecases/add_user_xp_usecase.dart';
import 'package:habitit/domain/rewards/usecases/get_user_rewards_usecase.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';

import '../../../service_locator.dart';

class UserRewardsCubit extends Cubit<UserRewardsState> {
  UserRewardsCubit() : super(UserRewardsInitial()) {
    getUserRewards();
  }

  UserRewardEntity? _rewardEntity;

  void getUserRewards() async {
    emit(UserRewardsLoading(_rewardEntity));
    var userRewards = await sl.get<GetUserRewardsUseCase>().call();
    userRewards.fold(
      (l) => emit(UserRewardsError(error: l)),
      (r) {
        _rewardEntity = r;
        emit(UserRewardsLoaded(rewards: r));
      },
    );
  }

  void updateUserRewards({required int xp}) async {
    await sl.get<AddUserXpUseCase>().call(params: xp);
  }

  bool get hasData => _rewardEntity != null;

  UserRewardEntity? get rewardEntity => _rewardEntity;
}
