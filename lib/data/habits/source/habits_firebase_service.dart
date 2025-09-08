import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habitit/data/habits/models/habit_network_model.dart';

abstract class HabitsFirebaseService {
  Future<HabitNetworkModel> addHabit({required HabitNetworkModel habit});

  Future<List<HabitNetworkModel>> getAllHabits();

  Future<HabitNetworkModel> getHabit({required String id});

  Future<HabitNetworkModel> editHabit({required HabitNetworkModel edited});

  Future<void> deleteHabit({required HabitNetworkModel habit});
}

class HabitsFirebaseServiceImpl implements HabitsFirebaseService {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<HabitNetworkModel> addHabit({required HabitNetworkModel habit}) async {
    try {
      return await ref
          .doc(user!.uid)
          .collection('Habits')
          .doc(habit.id)
          .set(habit.toJson())
          .then((value) => habit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HabitNetworkModel>> getAllHabits() async {
    try {
      return await ref
          .doc(user!.uid)
          .collection('Habits')
          .get()
          .then((onValue) => onValue.docs
              .map(
                (e) => HabitNetworkModel.fromJson(e.data()),
              )
              .toList());
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Future<HabitNetworkModel> getHabit({required String id}) async {
    try {
      var habitData = await ref
          .doc(user!.uid)
          .collection('Habits')
          .where('id', isEqualTo: id)
          .get()
          .then(
            (value) => value.docs.first.data(),
          );
      return HabitNetworkModel.fromJson(habitData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HabitNetworkModel> editHabit(
      {required HabitNetworkModel edited}) async {
    try {
      return await ref
          .doc(user!.uid)
          .collection('Habits')
          .doc(edited.id)
          .set(edited.toJson())
          .then((_) => edited);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit({required HabitNetworkModel habit}) async {
    try {
      await ref.doc(user!.uid).collection('Habits').doc(habit.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
