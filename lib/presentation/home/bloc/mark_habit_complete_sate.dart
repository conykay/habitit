// ignore_for_file: public_member_api_docs, sort_constructors_first
class MarkHabitCompleteSate {}

class MarkHabitLoading extends MarkHabitCompleteSate {}

class MarkHabitLoaded extends MarkHabitCompleteSate {}

class MarkHabitFailed extends MarkHabitCompleteSate {
  final String? error;
  MarkHabitFailed({
    this.error,
  });
}

class MarkHabitInital extends MarkHabitCompleteSate {}
