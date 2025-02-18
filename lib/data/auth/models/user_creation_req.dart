import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserCreationReq extends Equatable {
  final String name;
  final String email;
  final String userId;
  const UserCreationReq({
    required this.name,
    required this.email,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'userId': userId,
    };
  }

  factory UserCreationReq.fromMap(Map<String, dynamic> map) {
    return UserCreationReq(
      name: map['name'] as String,
      email: map['email'] as String,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCreationReq.fromJson(String source) =>
      UserCreationReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [name, email, userId];
}
