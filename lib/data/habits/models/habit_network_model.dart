// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/habits/entities/habit_entity.dart';
import 'habit_frequency.dart';

part 'habit_network_model.freezed.dart';
part 'habit_network_model.g.dart';

@freezed
abstract class HabitNetworkModel with _$HabitNetworkModel {
  const factory HabitNetworkModel({
    required String id,
    required String name,
    @Default('') String description,
    required HabitFrequency frequency,
    required DateTime startDate,
    @Default([]) List<DateTime> completedDates,
  }) = _HabitNetworkModel;

  factory HabitNetworkModel.fromJson(Map<String, Object?> json) =>
      _$HabitNetworkModelFromJson(json);
}

extension HabitToEntity on HabitNetworkModel {
  HabitEntity toEntity() => HabitEntity(
        id: id,
        name: name,
        description: description,
        frequency: frequency,
        startDate: startDate,
        completedDates: completedDates,
      );
}

extension HabitToModel on HabitEntity {
  HabitNetworkModel toNetworkModel() => HabitNetworkModel(
        id: id,
        name: name,
        description: description,
        frequency: frequency,
        startDate: startDate,
        completedDates: completedDates ?? [],
      );
}
