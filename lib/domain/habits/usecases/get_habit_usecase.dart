// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/data/habits/repository/habits_repository_impl.dart';

class GetHabitUsecase extends UseCase<Either, String> {
  final HabitsRepositoryImpl repository;
  GetHabitUsecase({
    required this.repository,
  });
  @override
  Future<Either> call({String? params}) async {
    return await repository.getHabit(id: params!);
  }
}
