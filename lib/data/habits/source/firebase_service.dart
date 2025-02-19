import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/data/habits/models/habit_model.dart';

abstract class FirebaseService {
  Future<void> addHabit({required HabitModel habit});
  Future<List<HabitModel>> getAllHabits();
  Future<HabitModel> getHabit({required String id});
}

class FirebaseServiceImpl implements FirebaseService {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> addHabit({required HabitModel habit}) async {
    try {
      await ref.doc(user.uid).collection('Habits').add(habit.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    try {
      var habitData = await ref.doc(user.uid).collection('Habits').get();
      return habitData.docs.map((e) => HabitModel.fromMap(e.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HabitModel> getHabit({required String id}) async {
    try {
      var habitData = await ref
          .doc(user.uid)
          .collection('Habits')
          .where('id', isEqualTo: id)
          .get();
      return HabitModel.fromMap(habitData.docs.first.data());
    } catch (e) {
      rethrow;
    }
  }
}
