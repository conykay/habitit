import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/habits/usecases/add_habit_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_habit_usecase_test.mocks.dart';

@GenerateMocks([HabitRepository])
void main() {
  late MockHabitRepository repository;
  late AddHabitUsecase usecase;

  setUp(() {
    repository = MockHabitRepository();
    usecase = AddHabitUsecase(habitRepository: repository);
  });

  final tHabitEntity = HabitEnity(
      id: 'id',
      name: 'name',
      frequency: HabitFrequency.daily,
      startDate: Timestamp.now());

  test('Add new habit is completed successfuly', () async {
    when(repository.addHabit(habit: tHabitEntity))
        .thenAnswer((_) async => Right('success'));
    var result = await usecase.call(params: tHabitEntity);
    expect(result, Right('success'));
    verify(repository.addHabit(habit: tHabitEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('failed to create new habit', () async {
    when(repository.addHabit(habit: tHabitEntity))
        .thenAnswer((_) async => Left('failed'));
    var result = await usecase.call(params: tHabitEntity);
    expect(result, Left('failed'));
    verify(repository.addHabit(habit: tHabitEntity)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
