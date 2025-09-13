import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';

part 'user_rewards_model.freezed.dart';
part 'user_rewards_model.g.dart';

@freezed
class UserRewardsNetworkModel with _$UserRewardsNetworkModel {
  const factory UserRewardsNetworkModel({
    required int xp,
    required int level,
    required List<String> earnedBadges,
  }) = _UserRewardsNetworkModel;

  factory UserRewardsNetworkModel.fromJson(Map<String, dynamic> json) =>
      _$UserRewardsNetworkModelFromJson(json);
}

extension UserRewardsToEntity on UserRewardsNetworkModel {
  UserRewardEntity toEntity() => UserRewardEntity(
        xp: xp,
        level: level,
        earnedBadges: earnedBadges,
      );
}

extension UserRewardsToModel on UserRewardEntity {
  UserRewardsNetworkModel toModel() => UserRewardsNetworkModel(
        xp: xp,
        level: level,
        earnedBadges: earnedBadges,
      );
}
