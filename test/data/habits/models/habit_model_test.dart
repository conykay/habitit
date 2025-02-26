import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/data/habits/models/habit_frequency.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';

void main() {
  final tHabitModel = HabitModel(
    id: 'id',
    name: 'name',
    description: 'description',
    frequency: HabitFrequency.daily,
    startDate: DateTime.now(),
    completedDates: [],
    synced: false,
  );

  test('should convert HabitModel to Map', () {
    final result = tHabitModel.toMap();
    expect(result, {
      'id': 'id',
      'name': 'name',
      'description': 'description',
      'frequency': 'daily',
      'startDate': tHabitModel.startDate.toIso8601String(),
      'completedDates': [],
      'synced': false,
    });
  });

  test('should create HabitModel from Map', () {
    final map = {
      'id': 'id',
      'name': 'name',
      'description': 'description',
      'frequency': 'daily',
      'startDate': tHabitModel.startDate.toIso8601String(),
      'completedDates': [],
      'synced': false,
    };
    final result = HabitModel.fromMap(map);
    expect(result, tHabitModel);
  });

  test('should convert HabitModel to JSON', () {
    final result = tHabitModel.toJson();
    print(result);
    final expectedJson = json.encode({
      'id': 'id',
      'name': 'name',
      'description': 'description',
      'frequency': 'daily',
      'startDate': tHabitModel.startDate.toIso8601String(),
      'completedDates': [],
      'synced': false,
    });
    expect(result, expectedJson);
  });

  test('should create HabitModel from JSON', () {
    final jsonString = json.encode({
      'id': 'id',
      'name': 'name',
      'description': 'description',
      'frequency': 'daily',
      'startDate': tHabitModel.startDate.toIso8601String(),
      'completedDates': [],
      'synced': false,
    });
    final result = HabitModel.fromJson(jsonString);
    expect(result, tHabitModel);
  });

  test('should convert HabitModel to HabitEntity', () {
    final result = tHabitModel.toEntity();
    final expectedEntity = HabitEnity(
      id: 'id',
      name: 'name',
      description: 'description',
      frequency: HabitFrequency.daily,
      startDate: Timestamp.fromDate(tHabitModel.startDate),
      synced: true,
      completedDates: [],
    );
    expect(result, expectedEntity);
  });
}
