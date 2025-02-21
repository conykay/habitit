import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/data/habits/models/habit_model.dart';

abstract class FirebaseService {
  Future<void> addHabit({required HabitModel habit});
  Future<List<HabitModel>> getAllHabits();
  Future<HabitModel> getHabit({required String id});
  Future<void> editHabit({required HabitModel edited});
}

class FirebaseServiceImpl implements FirebaseService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> addHabit({required HabitModel habit}) async {
    try {
      var docRef = ref.doc(user!.uid).collection('Habits').doc(habit.id);
      habit.synced = true;
      await docRef.set(habit.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitModel>> getAllHabits() async {
    try {
      var habitData = await ref.doc(user!.uid).collection('Habits').get();
      return habitData.docs.map((e) => HabitModel.fromMap(e.data())).toList();
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<HabitModel> getHabit({required String id}) async {
    try {
      var habitData = await ref
          .doc(user!.uid)
          .collection('Habits')
          .where('id', isEqualTo: id)
          .get();
      return HabitModel.fromMap(habitData.docs.first.data());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editHabit({required HabitModel edited}) async {
    try {
      var docRef = ref.doc(user!.uid).collection('Habits').doc(edited.id);
      edited.synced = true;
      await docRef.set(edited.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
