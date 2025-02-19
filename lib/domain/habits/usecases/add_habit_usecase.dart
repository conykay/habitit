// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

class AddHabitUsecase extends UseCase<Either, HabitEnity> {
  final HabitRepository habitRepository;
  AddHabitUsecase({
    required this.habitRepository,
  });
  @override
  Future<Either> call({HabitEnity? params}) async {
    return await habitRepository.addHabit(habit: params!);
  }
}
