// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../../../service_locator.dart';

class GetAllHabitsUseCase {
  Stream<Either> call() {
    return sl.get<HabitsRepository>().getAllHabits();
  }
}
