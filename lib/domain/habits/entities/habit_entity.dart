// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../../data/habits/models/habit_frequency.dart';

part 'habit_entity.freezed.dart';
part 'habit_entity.g.dart';

@freezed
abstract class HabitEntity extends HiveObject with _$HabitEntity {
  HabitEntity._();

  @HiveType(typeId: 0)
  factory HabitEntity({
    @HiveField(1) required String id,
    @HiveField(2) required String name,
    @HiveField(3) @Default('') String description,
    @HiveField(4) required HabitFrequency frequency,
    @HiveField(5) required DateTime startDate,
    @HiveField(6) List<DateTime>? completedDates,
    @HiveField(7) @Default(false) bool synced,
  }) = _HabitEntity;
}
