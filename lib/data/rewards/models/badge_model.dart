// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';

@freezed
class BadgeModel with _$BadgeModel {
  factory BadgeModel({
    required String id,
    required String name,
    required String description,
    required List<Color> colors,
    @Default(0) int requiredXp,
    @Default('') String criteria,
    @Default(Icons.star) IconData icon,
  }) = _BadgeModel;
}
