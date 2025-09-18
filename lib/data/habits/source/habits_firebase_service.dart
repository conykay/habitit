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
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  HabitsFirebaseServiceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = auth,
        _firestore = firestore;

  // Add habits to Firestore
  @override
  Future<HabitNetworkModel> addHabit({required HabitNetworkModel habit}) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the current user
    final User? user = _firebaseAuth.currentUser;

    try {
      // Add the habit to the "Habits" collection of the user's document
      return await userCollectionRef
          .doc(user!.uid)
          .collection('Habits')
          .doc(habit.id)
          .set(habit.toJson())
          .then((value) => habit);
    } catch (e) {
      throw Exception('Failed to add habit to Firestore: $e');
    }
  }

// Get all habits from Firestore
  @override
  Future<List<HabitNetworkModel>> getAllHabits() async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the current user
    final User? user = _firebaseAuth.currentUser;
    try {
      // Get all habits from the "Habits" collection of the user's document
      QuerySnapshot<Map<String, dynamic>> habitsSnapshot =
          await userCollectionRef.doc(user!.uid).collection('Habits').get();
      // Convert the query snapshot to a list of HabitNetworkModel objects and return it
      return habitsSnapshot.docs
          .map((e) => HabitNetworkModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get habits from Firestore: $e');
    }
  }

// Get a specific habit from Firestore
  @override
  Future<HabitNetworkModel> getHabit({required String id}) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the current user
    final User? user = _firebaseAuth.currentUser;
    try {
      // Get the habit with the specified ID from the "Habits" collection of the user's document
      QuerySnapshot<Map<String, dynamic>> habitSnapshot =
          await userCollectionRef
              .doc(user!.uid)
              .collection('Habits')
              .where('id', isEqualTo: id)
              .get();
      // Convert the query snapshot to a HabitNetworkModel object and return it
      Map<String, dynamic> habitData = habitSnapshot.docs.first.data();
      return HabitNetworkModel.fromJson(habitData);
    } catch (e) {
      throw Exception('Failed to get habit from Firestore: $e');
    }
  }

  // Edit a specific habit in Firestore
  @override
  Future<HabitNetworkModel> editHabit(
      {required HabitNetworkModel edited}) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the current user
    final User? user = _firebaseAuth.currentUser;
    // Update the habit with the specified ID in the "Habits" collection of the user's document
    try {
      return await userCollectionRef
          .doc(user!.uid)
          .collection('Habits')
          .doc(edited.id)
          .set(edited.toJson())
          .then((_) => edited);
    } catch (e) {
      throw Exception('Failed to edit habit in Firestore: $e');
    }
  }

  // Delete a specific habit from Firestore
  @override
  Future<void> deleteHabit({required HabitNetworkModel habit}) async {
    // Create a reference to the "Users" collection
    final CollectionReference userCollectionRef =
        _firestore.collection('Users');
    // Get the current user
    final User? user = _firebaseAuth.currentUser;
    // Delete the habit with the specified ID from the "Habits" collection of the user's document
    try {
      await userCollectionRef
          .doc(user!.uid)
          .collection('Habits')
          .doc(habit.id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete habit from Firestore: $e');
    }
  }
}
