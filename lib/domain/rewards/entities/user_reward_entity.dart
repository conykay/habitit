import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_reward_entity.freezed.dart';
part 'user_reward_entity.g.dart';

@unfreezed
class UserRewardEntity extends HiveObject with _$UserRewardEntity {
  UserRewardEntity._();

  @HiveType(typeId: 3)
  factory UserRewardEntity({
    @HiveField(0) @Default(0) int xp,
    @HiveField(1) @Default(1) int level,
    @HiveField(2) @Default([]) List<String> earnedBadges,
    @HiveField(3) @Default(false) bool synced,
  }) = _UserRewardEntity;
}
