import 'package:habitit/domain/habits/entities/habit_entity.dart';
import 'package:hive/hive.dart';

abstract class HabitsHiveService {
  Future<void> addHabit({required HabitEntity habit});

  Future<List<HabitEntity>> getAllHabits();

  Future<HabitEntity> getHabit({required String id});

  Future<void> editHabit({required HabitEntity edited});

  Future<void> deleteHabit({required HabitEntity habit});
}

class HabitsHiveServiceImpl implements HabitsHiveService {
  @override
  Future<void> addHabit({required HabitEntity habit}) async {
    final habitBox = await Hive.openBox<HabitEntity>('Habits');
    try {
      await habitBox.put(habit.id, habit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    final habitBox = await Hive.openBox<HabitEntity>('Habits');
    try {
      return habitBox.values.toList();
    } catch (e) {
      throw ('$e' 'Error in getting all habits');
    }
  }

  @override
  Future<HabitEntity> getHabit({required String id}) async {
    final habitBox = await Hive.openBox<HabitEntity>('Habits');
    try {
      return habitBox.get(id)!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editHabit({required HabitEntity edited}) async {
    final habitBox = await Hive.openBox<HabitEntity>('Habits');
    try {
      habitBox.put(edited.id, edited);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit({required HabitEntity habit}) async {
    final habitBox = await Hive.openBox<HabitEntity>('Habits');
    try {
      await habitBox.delete(habit.id);
    } catch (e) {
      rethrow;
    }
  }
}
