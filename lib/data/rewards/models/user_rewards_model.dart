// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:habitit/domain/rewards/entities/user_reward_entity.dart';
import 'package:hive/hive.dart';

part 'user_rewards_model.g.dart';

@HiveType(typeId: 3)
// ignore: must_be_immutable
class UserRewardsModel extends Equatable {
  @HiveField(0)
  int xp;

  @HiveField(1)
  int level;

  @HiveField(2)
  List<String> earnedBadges;

  @HiveField(3)
  bool _synced;

  UserRewardsModel({
    bool synced = false,
    required this.xp,
    required this.level,
    required this.earnedBadges,
  }) : _synced = synced;

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'xp': xp,
      'level': level,
      'earnedBadges': earnedBadges,
      'synced': synced,
    };
  }

  factory UserRewardsModel.fromMap(Map<String, dynamic> map) {
    return UserRewardsModel(
      xp: map['xp'] as int,
      level: map['level'] as int,
      earnedBadges: List<String>.from(map['earnedBadges'] as List),
      synced: map['synced'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRewardsModel.fromJson(String source) =>
      UserRewardsModel.fromMap(json.decode(source) as Map<String, dynamic>);
  @override
  List<Object> get props => [xp, level, earnedBadges, synced];

  @override
  bool get synced => _synced;

  @override
  set synced(bool value) {
    _synced = value;
  }
}

extension UserRewardsXEntity on UserRewardsModel {
  UserRewardEntity toEntity() => UserRewardEntity(
        xp: xp,
        level: level,
        earnedBadges: earnedBadges,
        synced: synced,
      );
}

extension UserRewardsXModel on UserRewardEntity {
  UserRewardsModel toModel() => UserRewardsModel(
        xp: xp,
        level: level,
        earnedBadges: earnedBadges,
        synced: synced,
      );
}
