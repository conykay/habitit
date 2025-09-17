// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';

import '../repository/habit_repository.dart';

class GetHabitUseCase extends UseCase<Either, String> {
  GetHabitUseCase({required HabitsRepository habitsRepository})
      : _habitsRepository = habitsRepository;
  final HabitsRepository _habitsRepository;
  @override
  Future<Either> call({String? params}) async {
    return await _habitsRepository.getHabit(id: params!);
  }
}
