// File: lib/core/sync_coordinator.dart

import 'dart:async';

import 'package:habitit/core/sync/syncable.dart';
import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../data/habits/source/firebase_service.dart';

class SyncCoordinator {
  final FirebaseService firebaseService;
  final Box<HabitModel> habitBox;
  late final List<GenericSyncManager<dynamic>> _syncManagers;

  late final StreamSubscription _connectivitySubscription;
  Timer? _periodicTimer;

  SyncCoordinator({
    required this.firebaseService,
    required this.habitBox,
  }) {
    _syncManagers = [
      GenericSyncManager<HabitModel>(
        box: habitBox,
        syncFunction: (habit) async =>
            await firebaseService.addHabit(habit: habit),
      ),
    ];
  }

  void initialize() {
    _connectivitySubscription =
        InternetConnectionChecker.instance.onStatusChange.listen((result) {
      if (result != InternetConnectionStatus.disconnected) {
        _syncAll();
        _pullAll();
      }
    });

    // Periodic sync every 15 minutes
    _periodicTimer = Timer.periodic(Duration(minutes: 1), (_) {
      print('The sync manager is active');
      _syncAll();
    });
  }

  Future<void> _syncAll() async {
    for (var manager in _syncManagers) {
      try {
        await manager.sync();
      } catch (e) {
        print('Error syncing manager (${manager.runtimeType}): $e');
      }
    }
  }

  Future<void> _pullAll() async {
    try {
      await firebaseService.getAllHabits();
    } catch (e) {
      print('Error pulling data from Firebase: $e');
    }
  }

  Future<void> dispose() async {
    await _connectivitySubscription.cancel();
    _periodicTimer?.cancel();
  }
}
