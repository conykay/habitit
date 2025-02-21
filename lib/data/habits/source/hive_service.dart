import 'package:habitit/data/habits/models/habit_model.dart';
import 'package:hive/hive.dart';

abstract class HiveService {
  Future<void> addHabit({required HabitModel habit});
  Future<List<HabitModel>> getAllHabits();
  Future<HabitModel> getHabit({required String id});
  Future<void> editHabit({required HabitModel edited});
  Future<void> deleteHabit({required HabitModel habit});
}

class HiveServiceImpl implements HiveService {
  @override
  Future<void> addHabit({required HabitModel habit}) async {
    final habitBox = await Hive.openBox<HabitModel>('Habits');
    try {
      await habitBox.put(habit.id, habit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    final habitBox = await Hive.openBox<HabitModel>('Habits');
    try {
      return habitBox.values.toList();
    } catch (e) {
      throw ('$e' 'Error in getting all habits');
    }
  }

  @override
  Future<HabitModel> getHabit({required String id}) async {
    final habitBox = await Hive.openBox<HabitModel>('Habits');
    try {
      return habitBox.get(id)!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editHabit({required HabitModel edited}) async {
    final habitBox = await Hive.openBox<HabitModel>('Habits');
    try {
      habitBox.put(edited.id, edited);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit({required HabitModel habit}) async {
    final habitBox = await Hive.openBox<HabitModel>('Habits');
    try {
      await habitBox.delete(habit.id);
    } catch (e) {
      rethrow;
    }
  }
}
