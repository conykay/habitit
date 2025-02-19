// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:habitit/data/habits/models/habit_model.dart';

import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';

import '../source/firebase_service.dart';
import '../source/hive_service.dart';

class HabitsRepositoryImpl implements HabitRepository {
  final HiveService _hiveService;
  final FirebaseService _firebaseService;
  HabitsRepositoryImpl({
    required HiveService hiveService,
    required FirebaseService firebaseService,
  })  : _hiveService = hiveService,
        _firebaseService = firebaseService;

  @override
  Future<Either> addHabit({required HabitEnity habit}) async {
    final connectivity = await Connectivity().checkConnectivity();
    final bool isOnline = connectivity != ConnectivityResult.none;
    final HabitModel habitModel = habit.toModel();
    try {
      if (isOnline) {
        try {
          await _firebaseService.addHabit(habit: habitModel);
          habitModel.synced = true;
        } catch (e) {
          habitModel.synced = false;
        }
      } else {
        habitModel.synced = false;
      }
      await _hiveService.addHabit(habit: habitModel);
      return Right('Saved success fully');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
