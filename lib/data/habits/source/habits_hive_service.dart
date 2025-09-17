import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/db/hive_core.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:hive/hive.dart';

abstract class HabitsHiveService extends HiveCore {
  Future<void> addHabit({required HabitEntity habit});

  Future<List<HabitEntity>> getAllHabits();

  Future<HabitEntity?> getHabit({required String id});

  Future<void> editHabit({required HabitEntity edited});

  Future<void> deleteHabit({required String id});
}

class HabitsHiveServiceImpl implements HabitsHiveService {
  late final Box<HabitEntity> _habitBox;

  HabitsHiveServiceImpl._(this._habitBox);

  // Singleton instance
  static Future<HabitsHiveServiceImpl> getInstance(
      {required FirebaseAuth auth}) async {
    //get the current user
    final User? user = auth.currentUser;
    //check if the box is already open and return it if it is
    final boxName = 'habits_${user?.uid}'.toLowerCase();
    Box<HabitEntity> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<HabitEntity>(boxName);
    } else {
      box = await Hive.openBox<HabitEntity>(boxName);
    }
    //return the instance
    return HabitsHiveServiceImpl._(box);
  }

//add habit to hive
  @override
  Future<void> addHabit({required HabitEntity habit}) async {
    //check if the box is open
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open attempting to add habit.');
    }
    //add the habit to the box
    try {
      await _habitBox.put(habit.id, habit);
    } catch (e) {
      throw Exception('Failed to add habit to Hive: $e');
    }
  }

  //get all habits from hive
  @override
  Future<List<HabitEntity>> getAllHabits() async {
    //check if the box is open
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when attempting to get all habits.');
    }
    //get all habits from the box
    try {
      return _habitBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get all habits from Hive: $e');
    }
  }

  //get a specific habit from hive using the id
  @override
  Future<HabitEntity?> getHabit({required String id}) async {
    //check if the box is open
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when attempting to get a habit.');
    }
    //get the habit from the box
    try {
      return _habitBox.get(id);
    } catch (e) {
      throw Exception('Failed to get habit from Hive: $e');
    }
  }

  //edit a specific habit in hive
  @override
  Future<void> editHabit({required HabitEntity edited}) async {
    //check if the box is open
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when attempting to edit a habit.');
    }
    //edit the habit in the box
    try {
      _habitBox.put(edited.id, edited);
    } catch (e) {
      throw Exception('Failed to edit habit in Hive: $e');
    }
  }

  //delete a specific habit from hive
  @override
  Future<void> deleteHabit({required String id}) async {
    //check if the box is open
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when attempting to delete a habit.');
    }
    //delete the habit from the box
    try {
      if (_habitBox.containsKey(id)) {
        await _habitBox.delete(id);
      }
    } catch (e) {
      throw Exception('Failed to delete habit from Hive: $e');
    }
  }

  //close the box
  @override
  Future<void> close() async {
    if (_habitBox.isOpen) {
      await _habitBox.close();
    }
  }
}
