// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../core/navigation/navigation.dart';

class NavigationState extends Equatable {
  final NavItem navItem;
  final int index;
  const NavigationState({
    required this.navItem,
    required this.index,
  });

  @override
  List<Object?> get props => [navItem, index];
}
