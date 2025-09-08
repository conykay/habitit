// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/habits/models/habit_network_model.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../../../service_locator.dart';
import '../source/habits_firebase_service.dart';
import '../source/habits_hive_service.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  @override
  Future<Either> addHabit({required HabitEntity habit}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      // add to local
      await hiveService.addHabit(habit: habit);
      // add to network and update habit sync
      if (isOnline) {
        try {
          var syncedHabit =
              await firebaseService.addHabit(habit: habit.toNetworkModel());
          //if add to network success
          await hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
        } catch (e) {
          print(
              'Failed to add habit: name(${habit.name}) to remote. Error: ${e.toString()}');
        }
      }
    } catch (e) {
      return Left('failed to update Db addHabit():  ${e.toString()}');
    }

    return Right('Saved successfully');
  }

  @override
  Future<Either> getAllHabits() async {
    List<HabitEntity>? allHabits;
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      //get all from local db
      allHabits = await hiveService.getAllHabits();
      //check user online
      if (isOnline) {
        //check for unsynced habits & sync
        var unsyncedHabits =
            allHabits.where((element) => !element.synced).toList();
        for (var sync in unsyncedHabits) {
          try {
            await firebaseService.editHabit(edited: sync.toNetworkModel());
            await hiveService.editHabit(edited: sync.copyWith(synced: true));
          } catch (e) {
            print(
                'Failed to sync habit: name(${sync.name}) to remote. Error: ${e.toString()}');
          }
        }
        //retrieve updated list
        allHabits = await hiveService.getAllHabits();
      }
    } catch (e) {
      return Left('Failed to retrieve allHabits(): ${e.toString()} ');
    }
    return Right(allHabits);
  }

  @override
  Future<Either> getHabit({required String id}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    HabitEntity? habit;

    try {
      //get from local db
      habit = await hiveService.getHabit(id: id);
      //check if is synced and try to if not
      if (!habit.synced && isOnline) {
        try {
          final HabitNetworkModel syncedHabit =
              await firebaseService.editHabit(edited: habit.toNetworkModel());
          await hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
          //updated habit
          habit = await hiveService.getHabit(id: id);
        } catch (e) {
          print('Failed to sync habit getHabit(): ${e.toString()}');
        }
      }
    } catch (e) {
      return Left('Failed to retrieve getHabit(): ${e.toString()} ');
    }

    return Right(habit);
  }

  @override
  Future<Either> editHabit({required HabitEntity habit}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      // edit local copy
      await hiveService.editHabit(edited: habit.copyWith(synced: false));
      //edit remote copy
      if (isOnline) {
        try {
          final HabitNetworkModel syncedHabit =
              await firebaseService.editHabit(edited: habit.toNetworkModel());
          //if edit to network success
          await hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
        } catch (e) {
          print(
              'Failed to sync habit: name(${habit.name}) to remote. Error: ${e.toString()}');
        }
      }
    } catch (e) {
      return Left('Failed to editHabit(): ${e.toString()}');
    }

    return Right('Edited successfully');
  }

  @override
  Future<Either> deleteHabit({required HabitEntity habit}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      //delete local copy
      await hiveService.deleteHabit(habit: habit);
      //delete remote copy
      if (isOnline) {
        await firebaseService.deleteHabit(habit: habit.toNetworkModel());
      }
    } catch (e) {
      return Left('Failed to deleteHabit(): ${e.toString()}');
    }
    return Right('Deleted successfully');
  }
}

// todo:(Implement auto sync feature.) (Inform user when habits are synced irregardless of location on app)
