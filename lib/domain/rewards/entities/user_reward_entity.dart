import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserRewardEntity extends Equatable {
  int xp;
  int level;
  List<String> earnedBadges;
  bool synced;

  UserRewardEntity({
    this.xp = 0,
    this.level = 1,
    this.earnedBadges = const [],
    this.synced = false,
  });
  @override
  List<Object?> get props => [xp, level, earnedBadges, synced];
}
