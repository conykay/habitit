// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../data/habits/models/habit_frequency.dart';

class HabitEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final HabitFrequency frequency;
  final Timestamp startDate;
  final List<DateTime>? completedDates;
  final bool synced;
  const HabitEntity({
    required this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.startDate,
    this.completedDates,
    required this.synced,
  });

  @override
  List<Object?> get props =>
      [id, name, description, frequency, startDate, completedDates];
}
