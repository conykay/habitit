// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repository/habit_repository.dart';

class GetHabitUseCase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl.get<HabitsRepository>().getHabit(id: params!);
  }
}
