import 'package:dartz/dartz.dart';
import 'package:habitit/core/network/network_info.dart';
import 'package:habitit/data/habits/models/habit_network_model.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../source/habits_firebase_service.dart';
import '../source/habits_hive_service.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  final NetworkInfoService _networkService;
  final HabitsFirebaseService _firebaseService;
  final HabitsHiveService _hiveService;

  HabitsRepositoryImpl({
    required NetworkInfoService networkInfoService,
    required HabitsFirebaseService firebaseService,
    required HabitsHiveService hiveService,
  })  : _networkService = networkInfoService,
        _firebaseService = firebaseService,
        _hiveService = hiveService;

  // add habit to local and remote
  @override
  Future<Either> addHabit({required HabitEntity habit}) async {
    var isOnline = await _networkService.hasConnection;
    try {
      // add to local
      await _hiveService.addHabit(habit: habit);
      // add to network and update habit sync
      if (isOnline) {
        try {
          var syncedHabit =
              await _firebaseService.addHabit(habit: habit.toNetworkModel());
          //if add to network success
          await _hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
        } catch (e) {
          print(
              'Failed to add habit: name(${habit.name}) to remote. Error: ${e.toString()}');
        }
      }
      return Right('Saved successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  // get all habits from local and remote
  @override
  Stream<Either> getAllHabits() async* {
    var isOnline = await _networkService.hasConnection;
    try {
      //get all from local db
      List<HabitEntity> allLocalHabits = await _hiveService.getAllHabits();
      //yield results if db has data
      if (allLocalHabits.isNotEmpty) {
        yield Right(allLocalHabits);
      }

      //check user online
      if (isOnline) {
        List<HabitNetworkModel> networkAllHabits =
            await _firebaseService.getAllHabits();
        //check if db is empty and add all from network

        if (allLocalHabits.isEmpty) {
          for (var habit in networkAllHabits) {
            await _hiveService.addHabit(habit: habit.toEntity());
          }
        }

        //check for unsynced habits & sync
        var unsyncedHabits =
            allLocalHabits.where((element) => !element.synced).toList();
        for (var sync in unsyncedHabits) {
          try {
            await _firebaseService.editHabit(edited: sync.toNetworkModel());
            await _hiveService.editHabit(edited: sync.copyWith(synced: true));
          } catch (e) {
            print(
                'Failed to sync habit: name(${sync.name}) to remote. Error: ${e.toString()}');
          }
        }
        //retrieve updated list
        allLocalHabits = await _hiveService.getAllHabits();
        yield Right(allLocalHabits);
      }
    } catch (e) {
      yield Left(e.toString());
    }
  }

  // get habit from local and remote
  @override
  Future<Either> getHabit({required String id}) async {
    var isOnline = await _networkService.hasConnection;
    HabitEntity? localHabit;

    try {
      //get from local db
      localHabit = await _hiveService.getHabit(id: id);
      //get from network if null
      if (isOnline) {
        if (localHabit == null) {
          try {
            final HabitNetworkModel networkHabit =
                await _firebaseService.getHabit(id: id);
            await _hiveService.addHabit(
                habit: networkHabit.toEntity().copyWith(synced: true));
          } catch (e) {
            print(
                'Failed to retrieve habit from network id: $id. Error: ${e.toString()}');
          }
        }
        //check if is synced and try to if not
        if (localHabit != null && !localHabit.synced) {
          try {
            final HabitNetworkModel syncedHabit = await _firebaseService
                .editHabit(edited: localHabit.toNetworkModel());
            await _hiveService.editHabit(
                edited: syncedHabit.toEntity().copyWith(synced: true));
          } catch (e) {
            print('Failed to sync habit getHabit(): ${e.toString()}');
          }
        }
        //updated habit
        localHabit = await _hiveService.getHabit(id: id);
      }

      return Right(localHabit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // edit habit to local and remote
  @override
  Future<Either> editHabit({required HabitEntity habit}) async {
    var isOnline = await _networkService.hasConnection;

    try {
      // edit local copy
      await _hiveService.editHabit(edited: habit.copyWith(synced: false));
      //edit remote copy
      if (isOnline) {
        try {
          final HabitNetworkModel syncedHabit =
              await _firebaseService.editHabit(edited: habit.toNetworkModel());
          //if edit to network success
          await _hiveService.editHabit(
              edited: syncedHabit.toEntity().copyWith(synced: true));
        } catch (e) {
          print(
              'Failed to sync habit: name(${habit.name}) to remote. Error: ${e.toString()}');
        }
      }

      return Right('Edited successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  // delete habit to local and remote
  @override
  Future<Either> deleteHabit({required HabitEntity habit}) async {
    var isOnline = await _networkService.hasConnection;

    try {
      // delete only if online
      if (!isOnline) return Left('You need to be online to delete a habit.');
      //delete remote copy
      await _firebaseService.deleteHabit(habit: habit.toNetworkModel());
      //delete local copy
      await _hiveService.deleteHabit(id: habit.id);

      return Right('Deleted successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }
}

// todo:(Implement auto sync feature.) (Inform user when habits are synced irregardless of location on app)
