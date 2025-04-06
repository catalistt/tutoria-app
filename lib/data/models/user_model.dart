import 'package:tutoria_app/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String grade;
  final String educationalGoal;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String? profileImageUrl;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.grade,
    required this.educationalGoal,
    required this.createdAt,
    required this.lastLoginAt,
    this.profileImageUrl,
  });
  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      grade: map['grade'] ?? '',
      educationalGoal: map['educationalGoal'] ?? '',
      createdAt: map['createdAt'] != null 
        ? (map['createdAt'] as dynamic).toDate() 
        : DateTime.now(),
      lastLoginAt: map['lastLoginAt'] != null 
        ? (map['lastLoginAt'] as dynamic).toDate() 
        : DateTime.now(),
      profileImageUrl: map['profileImageUrl'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'grade': grade,
      'educationalGoal': educationalGoal,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'profileImageUrl': profileImageUrl,
    };
  }
  
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      grade: grade,
      educationalGoal: educationalGoal,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      profileImageUrl: profileImageUrl,
    );
  }
  
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      grade: entity.grade,
      educationalGoal: entity.educationalGoal,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
      profileImageUrl: entity.profileImageUrl,
    );
  }
}
