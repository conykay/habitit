// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum ButtonStates { initial, loading, loaded, failed }

class ButtonState extends Equatable {
  final ButtonStates state;
  final dynamic error;
  final dynamic data;
  const ButtonState({
    required this.state,
    this.error,
    this.data,
  });

  @override
  List<Object?> get props => [state, error, data];
}
