// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../../../service_locator.dart';
import '../source/habits_firebase_service.dart';
import '../source/habits_hive_service.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  @override
  Future<Either> addHabit({required HabitModel habit}) async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    final hiveService = sl.get<HabitsHiveService>();

    try {
      if (isOnline) {
        try {
          await sl
              .get<HabitsFirebaseService>()
              .addHabit(habit: habit)
              .then((_) async {
            habit.synced = true;
            await hiveService.addHabit(habit: habit);
          });
        } catch (e) {
          habit.synced = false;
          return Left(e.toString());
        }
      } else {
        habit.synced = false;
        await hiveService.addHabit(habit: habit);
      }

      return Right('Saved success fully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllHabits() async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    final hiveService = sl.get<HabitsHiveService>();

    var habitList = <HabitModel>[];
    try {
      if (isOnline) {
        var localList = await hiveService.getAllHabits();
        var remoteList = await sl.get<HabitsFirebaseService>().getAllHabits();
        for (var element in remoteList) {
          if (!localList.contains(element)) {
            await hiveService.addHabit(habit: element);
          }
        }
        habitList = await hiveService.getAllHabits();
      } else {
        habitList = await hiveService.getAllHabits();
      }
      return Right(habitList.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getHabit({required String id}) async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    final hiveService = sl.get<HabitsHiveService>();

    try {
      HabitModel habit;
      if (isOnline) {
        habit = await sl.get<HabitsFirebaseService>().getHabit(id: id);
      } else {
        habit = await hiveService.getHabit(id: id);
      }
      return Right(habit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editHabit({required HabitEntity habit}) async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    final hiveService = sl.get<HabitsHiveService>();
    HabitModel editedHabit = habit.toModel();

    try {
      if (isOnline) {
        try {
          await sl
              .get<HabitsFirebaseService>()
              .editHabit(edited: editedHabit)
              .then((_) async {
            editedHabit.synced = true;
            await hiveService.editHabit(edited: editedHabit);
          });
        } catch (e) {
          editedHabit.synced = false;
          return Left(e.toString());
        }
      } else {
        editedHabit.synced = false;
        await hiveService.editHabit(edited: editedHabit);
      }

      return Right('Edited successfuly success fully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteHabit({required HabitEntity habit}) async {
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;
    final hiveService = sl.get<HabitsHiveService>();

    try {
      if (isOnline) {
        try {
          await sl
              .get<HabitsFirebaseService>()
              .deleteHabit(habit: habit.toModel())
              .then((_) async {
            await hiveService.deleteHabit(habit: habit.toModel());
          });
        } catch (e) {
          return Left(e.toString());
        }
      } else {
        throw Exception('Cannot perform this operation offline');
      }

      return Right('Deleted successfuly');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
