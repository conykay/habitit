// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';

class UserRewardsCubit extends Cubit<UserRewardsState> {
  UserRewardsCubit() : super(UserRewardsInitial());

  void getUserRewards({required UseCase usecase}) async {
    emit(UserRewardsLoading());
    var userRewards = await usecase.call();
    userRewards.fold(
      (l) => emit(UserRewardsError(error: l)),
      (r) => emit(UserRewardsLoaded(rewards: r)),
    );
  }

  void updateUserRewards({required UseCase usecase, required int xp}) async {
    await usecase.call(params: xp);
  }
}
