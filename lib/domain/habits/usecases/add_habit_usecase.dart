// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/usecase/usecase.dart';
import 'package:habitit/data/habits/models/habit_network_model.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../../../service_locator.dart';

class AddHabitUseCase extends UseCase<Either, HabitNetworkModel> {
  @override
  Future<Either> call({HabitNetworkModel? params}) async {
    return await sl.get<HabitsRepository>().addHabit(habit: params!.toEntity());
  }
}
