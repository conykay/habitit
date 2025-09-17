// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

class GetAllHabitsUseCase {
  GetAllHabitsUseCase({required HabitsRepository habitsRepository})
      : _habitsRepository = habitsRepository;
  final HabitsRepository _habitsRepository;
  Stream<Either> call() {
    return _habitsRepository.getAllHabits();
  }
}
