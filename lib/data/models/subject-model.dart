import 'package:tutoria_app/domain/entities/subject_entity.dart';

class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int order;
  final bool isActive;
  
  SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.order,
    required this.isActive,
  });
  
  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
      order: map['order'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'order': order,
      'isActive': isActive,
    };
  }
  
  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      order: order,
      isActive: isActive,
    );
  }
  
  factory SubjectModel.fromEntity(SubjectEntity entity) {
    return SubjectModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      order: entity.order,
      isActive: entity.isActive,
    );
  }
}
