// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_state.dart';

class UserRewardsCubit extends Cubit<UserRewardsState> {
  UserRewardsCubit(
    this.useCase,
  ) : super(UserRewardsInitial());

  final UseCase<Either, dynamic> useCase;
  void getUserRewards() async {
    emit(UserRewardsLoading());
    var userRewards = await useCase.call();
    userRewards.fold(
      (l) => emit(UserRewardsError(error: l)),
      (r) => emit(UserRewardsLoaded(rewards: r)),
    );
  }
}
