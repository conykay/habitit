// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

class GetAllHabitsUsecase extends UseCase<Either, dynamic> {
  final HabitRepository repository;
  GetAllHabitsUsecase({
    required this.repository,
  });
  @override
  Future<Either> call({params}) async {
    return await repository.getAllHabits();
  }
}
