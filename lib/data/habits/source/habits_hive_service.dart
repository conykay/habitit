import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/core/db/hive_core.dart';
import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:hive/hive.dart';

abstract class HabitsHiveService extends HiveCore {
  Future<void> addHabit({required HabitEntity habit});

  Future<List<HabitEntity>> getAllHabits();

  Future<HabitEntity?> getHabit({required String id});

  Future<void> editHabit({required HabitEntity edited});

  Future<void> deleteHabit({required HabitEntity habit});
}

class HabitsHiveServiceImpl implements HabitsHiveService {
  late final Box<HabitEntity> _habitBox;

  HabitsHiveServiceImpl._(this._habitBox);

  static Future<HabitsHiveServiceImpl> getInstance() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final boxName = 'habits_${user?.uid}'.toLowerCase();
    Box<HabitEntity> box;

    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<HabitEntity>(boxName);
    } else {
      box = await Hive.openBox<HabitEntity>(boxName);
    }
    print(
        'instance of habit service complete,${box.name} box is open: ${box.isOpen}');
    return HabitsHiveServiceImpl._(box);
  }

  @override
  Future<void> addHabit({required HabitEntity habit}) async {
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when addHabit() called ');
    }
    try {
      await _habitBox.put(habit.id, habit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    if (!_habitBox.isOpen) {
      print('is ${_habitBox.name} open: ${_habitBox.isOpen}');
      throw Exception('Habit box not open when getAllHabits() called ');
    }
    try {
      return _habitBox.values.toList();
    } catch (e) {
      throw ('$e' 'Error in getting all habits');
    }
  }

  @override
  Future<HabitEntity?> getHabit({required String id}) async {
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when getHabit() called ');
    }
    try {
      return _habitBox.get(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editHabit({required HabitEntity edited}) async {
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when editHabit() called ');
    }
    try {
      _habitBox.put(edited.id, edited);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit({required HabitEntity habit}) async {
    if (!_habitBox.isOpen) {
      throw Exception('Habit box not open when deleteHabit() called ');
    }
    try {
      if (_habitBox.containsKey(habit.id)) {
        await _habitBox.delete(habit.id);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    if (_habitBox.isOpen) {
      await _habitBox.close();
    }
  }
}
