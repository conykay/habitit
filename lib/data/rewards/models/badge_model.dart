// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BadgeModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int requiredXp;
  final String criteria;
  final IconData icon;
  final List<Color> colors;
  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    this.requiredXp = 0,
    this.criteria = '',
    this.icon = Icons.star,
  });

  @override
  List<Object?> get props =>
      [id, name, description, requiredXp, criteria, icon];
}
