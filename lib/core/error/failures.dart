// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  const Failures([List properties = const <dynamic>[]]) : super();
}

//authentication
class InvalidEmailFailure extends Failures {
  final String? error;
  const InvalidEmailFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class InvalidPasswordFailure extends Failures {
  final String? error;

  const InvalidPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class OtherFailure extends Failures {
  final String? error;

  const OtherFailure(this.error);

  @override
  List<Object?> get props => [error];
}
