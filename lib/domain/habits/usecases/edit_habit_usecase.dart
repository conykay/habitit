// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../../../service_locator.dart';

class EditHabitUseCase extends UseCase<Either, HabitEntity> {
  @override
  Future<Either> call({HabitEntity? params}) async {
    return await sl.get<HabitsRepository>().editHabit(habit: params!);
  }
}
