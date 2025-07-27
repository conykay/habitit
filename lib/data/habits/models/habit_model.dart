// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:habitit/core/sync/syncable.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:hive/hive.dart';

import 'habit_frequency.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
// ignore: must_be_immutable
class HabitModel extends HiveSyncable with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final HabitFrequency frequency;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final List<DateTime> completedDates;

  @HiveField(6)
  bool _synced;

  HabitModel({
    required this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.startDate,
    this.completedDates = const [],
    bool synced = false,
  }) : _synced = synced;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'frequency': frequency.toString().split('.').last,
      'startDate': startDate.toIso8601String(),
      'completedDates':
          completedDates.map((x) => x.millisecondsSinceEpoch).toList(),
      'synced': synced,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      frequency: HabitFrequency.values.firstWhere(
          (e) => e.toString().split('.').last == map['frequency'],
          orElse: () => HabitFrequency.daily),
      startDate: DateTime.parse(map['startDate']),
      completedDates: List.from(
        (map['completedDates']).map(
          (x) => DateTime.fromMillisecondsSinceEpoch(x),
        ),
      ),
      synced: map['synced'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory HabitModel.fromJson(String source) =>
      HabitModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props =>
      [id, name, description, frequency, startDate, completedDates, synced];

  @override
  bool get synced => _synced;

  @override
  set synced(bool value) {
    _synced = value;
  }
}

extension HabitEntityX on HabitModel {
  HabitEntity toEntity() => HabitEntity(
        id: id,
        name: name,
        description: description,
        frequency: frequency,
        startDate: Timestamp.fromDate(startDate),
        completedDates: completedDates,
        synced: synced,
      );
}

extension HabitModelX on HabitEntity {
  HabitModel toModel() => HabitModel(
      id: id,
      name: name,
      frequency: frequency,
      description: description,
      startDate: startDate.toDate(),
      synced: false,
      completedDates: completedDates ?? []);
}
