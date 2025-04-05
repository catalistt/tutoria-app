import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int order;
  final bool isActive;
  
  const SubjectEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.order,
    required this.isActive,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    order,
    isActive,
  ];
  
  SubjectEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? order,
    bool? isActive,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }
}
