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
  Stream<Either> getAllHabits() async* {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      //get all from local db
      List<HabitEntity> allLocalHabits = await hiveService.getAllHabits();
      //yield results if db has data
      if (allLocalHabits.isNotEmpty) {
        yield Right(allLocalHabits);
      }

      //check user online
      if (isOnline) {
        //check if db is empty
        if (allLocalHabits.isEmpty) {
          List<HabitNetworkModel> networkAllHabits =
              await firebaseService.getAllHabits();
          for (var habit in networkAllHabits) {
            await hiveService.addHabit(habit: habit.toEntity());
          }
        }

        //check for unsynced habits & sync
        var unsyncedHabits =
            allLocalHabits.where((element) => !element.synced).toList();
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
        allLocalHabits = await hiveService.getAllHabits();
        yield Right(allLocalHabits);
      }
    } catch (e) {
      yield Left('Failed to retrieve allHabits(): ${e.toString()} ');
    }
  }

  @override
  Future<Either> getHabit({required String id}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      //get from local db
      HabitEntity localHabit = await hiveService.getHabit(id: id);
      //check if is synced and try to if not
      if (!localHabit.synced && isOnline) {
        try {
          final HabitNetworkModel syncedHabit = await firebaseService.editHabit(
              edited: localHabit.toNetworkModel());
          await hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
          //updated habit
          localHabit = await hiveService.getHabit(id: id);
        } catch (e) {
          print('Failed to sync habit getHabit(): ${e.toString()}');
        }
      }
      return Right(localHabit);
    } catch (e) {
      return Left('Failed to retrieve getHabit(): ${e.toString()} ');
    }
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

      return Right('Edited successfully');
    } catch (e) {
      return Left('Failed to editHabit(): ${e.toString()}');
    }
  }

  @override
  Future<Either> deleteHabit({required HabitEntity habit}) async {
    final hiveService = sl.get<HabitsHiveService>();
    final firebaseService = sl.get<HabitsFirebaseService>();
    var isOnline = await sl.get<NetworkInfoService>().hasConnection;

    try {
      // delete only if online
      if (!isOnline) return Left('You need to be online to delete a habit.');
      //delete remote copy
      await firebaseService.deleteHabit(habit: habit.toNetworkModel());
      //delete local copy
      await hiveService.deleteHabit(habit: habit);

      return Right('Deleted successfully');
    } catch (e) {
      return Left('Failed to deleteHabit(): ${e.toString()}');
    }
  }
}

// todo:(Implement auto sync feature.) (Inform user when habits are synced irregardless of location on app)
