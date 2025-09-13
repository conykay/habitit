// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rewards_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRewardsNetworkModelImpl _$$UserRewardsNetworkModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserRewardsNetworkModelImpl(
      xp: (json['xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      earnedBadges: (json['earnedBadges'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserRewardsNetworkModelImplToJson(
        _$UserRewardsNetworkModelImpl instance) =>
    <String, dynamic>{
      'xp': instance.xp,
      'level': instance.level,
      'earnedBadges': instance.earnedBadges,
    };
