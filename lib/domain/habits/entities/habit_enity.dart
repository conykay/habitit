// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum HabitFrequency { daily, weekly }

class HabitEnity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final HabitFrequency frequency;
  final Timestamp startDate;
  final List<DateTime>? completedDates;
  const HabitEnity({
    required this.id,
    required this.name,
    this.description,
    required this.frequency,
    required this.startDate,
    this.completedDates,
  });

  @override
  List<Object?> get props => [id, name, description, frequency, startDate];
}
