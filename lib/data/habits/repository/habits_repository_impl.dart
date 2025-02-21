// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../source/firebase_service.dart';
import '../source/hive_service.dart';

class HabitsRepositoryImpl implements HabitRepository {
  final HiveService _hiveService;
  final FirebaseService _firebaseService;
  final NetworkInfo _networkInfo;

  HabitsRepositoryImpl({
    required HiveService hiveService,
    required FirebaseService firebaseService,
    required NetworkInfo networkInfo,
  })  : _hiveService = hiveService,
        _firebaseService = firebaseService,
        _networkInfo = networkInfo;

  @override
  Future<Either> addHabit({required HabitModel habit}) async {
    var isOnline = await _networkInfo.hasConection;

    try {
      if (isOnline) {
        try {
          await _firebaseService.addHabit(habit: habit).then((_) async {
            habit.synced = true;
            await _hiveService.addHabit(habit: habit);
          });
        } catch (e) {
          habit.synced = false;
          return Left(e.toString());
        }
      } else {
        habit.synced = false;
        await _hiveService.addHabit(habit: habit);
      }

      return Right('Saved success fully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getAllHabits() async {
    var isOnline = await _networkInfo.hasConection;

    var habitList = <HabitModel>[];
    try {
      if (isOnline) {
        var localList = await _hiveService.getAllHabits();
        var remoteList = await _firebaseService.getAllHabits();
        for (var element in remoteList) {
          if (!localList.contains(element)) {
            await _hiveService.addHabit(habit: element);
          }
        }
        habitList = await _hiveService.getAllHabits();
      } else {
        habitList = await _hiveService.getAllHabits();
      }
      return Right(habitList.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getHabit({required String id}) async {
    var isOnline = await _networkInfo.hasConection;

    try {
      HabitModel habit;
      if (isOnline) {
        habit = await _firebaseService.getHabit(id: id);
      } else {
        habit = await _hiveService.getHabit(id: id);
      }
      return Right(habit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editHabit({required HabitEnity habit}) async {
    var isOnline = await _networkInfo.hasConection;
    HabitModel editedHabit = habit.toModel();
    try {
      if (isOnline) {
        try {
          await _firebaseService.editHabit(edited: editedHabit).then((_) async {
            editedHabit.synced = true;
            await _hiveService.editHabit(edited: editedHabit);
          });
        } catch (e) {
          editedHabit.synced = false;
          return Left(e.toString());
        }
      } else {
        editedHabit.synced = false;
        await _hiveService.editHabit(edited: editedHabit);
      }

      return Right('Edited successfuly success fully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteHabit({required HabitEnity habit}) async {
    var isOnline = await _networkInfo.hasConection;
    try {
      if (isOnline) {
        try {
          await _firebaseService
              .deleteHabit(habit: habit.toModel())
              .then((_) async {
            await _hiveService.deleteHabit(habit: habit.toModel());
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
