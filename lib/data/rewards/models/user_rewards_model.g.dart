// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rewards_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRewardsModelAdapter extends TypeAdapter<UserRewardsModel> {
  @override
  final int typeId = 3;

  @override
  UserRewardsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRewardsModel(
      xp: fields[0] as int,
      level: fields[1] as int,
      earnedBadges: (fields[2] as List).cast<String>(),
    ).._synced = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, UserRewardsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.earnedBadges)
      ..writeByte(3)
      ..write(obj._synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRewardsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
