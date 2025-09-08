import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/data/habits/models/habit_frequency.dart';
import 'package:habitit/data/habits/models/habit_server_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/habits/usecases/add_habit_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_habit_usecase_test.mocks.dart';

@GenerateMocks([HabitsRepository])
void main() {
  late MockHabitRepository repository;
  late AddHabitUseCase usecase;

  setUp(() {
    repository = MockHabitRepository();
    usecase = AddHabitUseCase(habitRepository: repository);
  });

  final tHabitEntity = HabitEntity(
      id: 'id',
      name: 'name',
      frequency: HabitFrequency.daily,
      startDate: Timestamp.now(),
      synced: true);

  test('Add new habit is completed successfuly', () async {
    when(repository.addHabit(habit: tHabitEntity.toModel()))
        .thenAnswer((_) async => Right('success'));
    var result = await usecase.call(params: tHabitEntity.toModel());
    expect(result, Right('success'));
    verify(repository.addHabit(habit: tHabitEntity.toModel())).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('failed to create new habit', () async {
    when(repository.addHabit(habit: tHabitEntity.toModel()))
        .thenAnswer((_) async => Left('failed'));
    var result = await usecase.call(params: tHabitEntity.toModel());
    expect(result, Left('failed'));
    verify(repository.addHabit(habit: tHabitEntity.toModel())).called(1);
    verifyNoMoreInteractions(repository);
  });
}
