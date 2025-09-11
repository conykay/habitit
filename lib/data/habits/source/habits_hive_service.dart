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
  late Box<HabitEntity> _habitBox;
  final User? _user = FirebaseAuth.instance.currentUser;
  static const String _habitBoxName = 'Habits';

  HabitsHiveServiceImpl() {
    init();
  }

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_habitBoxName + _user!.uid)) {
      _habitBox = await Hive.openBox<HabitEntity>(_habitBoxName + _user.uid);
    }
  }

  @override
  Future<void> ensureBoxOpen() async {
    if (!_habitBox.isOpen) {
      await init();
    }
  }

  @override
  Future<void> addHabit({required HabitEntity habit}) async {
    await ensureBoxOpen();
    try {
      await _habitBox.put(habit.id, habit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitEntity>> getAllHabits() async {
    await ensureBoxOpen();
    try {
      return _habitBox.values.toList();
    } catch (e) {
      throw ('$e' 'Error in getting all habits');
    }
  }

  @override
  Future<HabitEntity?> getHabit({required String id}) async {
    await ensureBoxOpen();
    try {
      return _habitBox.get(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editHabit({required HabitEntity edited}) async {
    await ensureBoxOpen();
    try {
      _habitBox.put(edited.id, edited);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit({required HabitEntity habit}) async {
    await ensureBoxOpen();
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
    await _habitBox.close();
  }
}
