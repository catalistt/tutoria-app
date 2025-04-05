import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String grade;
  final String educationalGoal;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String? profileImageUrl;
  
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.grade,
    required this.educationalGoal,
    required this.createdAt,
    required this.lastLoginAt,
    this.profileImageUrl,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    email,
    grade,
    educationalGoal,
    createdAt,
    lastLoginAt,
    profileImageUrl,
  ];
  
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? grade,
    String? educationalGoal,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? profileImageUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      grade: grade ?? this.grade,
      educationalGoal: educationalGoal ?? this.educationalGoal,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
