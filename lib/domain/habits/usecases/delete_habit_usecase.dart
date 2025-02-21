// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

class DeleteHabitUsecase extends UseCase<Either, HabitEnity> {
  final HabitRepository repository;
  DeleteHabitUsecase({
    required this.repository,
  });
  @override
  Future<Either> call({HabitEnity? params}) async {
    return await repository.deleteHabit(habit: params!);
  }
}
