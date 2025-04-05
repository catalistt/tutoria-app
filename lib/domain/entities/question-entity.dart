import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String id;
  final String bankId;
  final String text;
  final String? imageUrl;
  final String type;
  final int difficulty;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final QuestionMetadata metadata;
  
  const QuestionEntity({
    required this.id,
    required this.bankId,
    required this.text,
    this.imageUrl,
    required this.type,
    required this.difficulty,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.metadata,
  });
  
  @override
  List<Object?> get props => [
    id,
    bankId,
    text,
    imageUrl,
    type,
    difficulty,
    options,
    correctAnswer,
    explanation,
    metadata,
  ];
  
  QuestionEntity copyWith({
    String? id,
    String? bankId,
    String? text,
    String? imageUrl,
    String? type,
    int? difficulty,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    QuestionMetadata? metadata,
  }) {
    return QuestionEntity(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      metadata: metadata ?? this.metadata,
    );
  }
}

class QuestionMetadata extends Equatable {
  final List<String> thematicAxis;
  final List<String> skills;
  final List<String> thematicUnits;
  
  const QuestionMetadata({
    required this.thematicAxis,
    required this.skills,
    required this.thematicUnits,
  });
  
  @override
  List<Object?> get props => [thematicAxis, skills, thematicUnits];
  
  QuestionMetadata copyWith({
    List<String>? thematicAxis,
    List<String>? skills,
    List<String>? thematicUnits,
  }) {
    return QuestionMetadata(
      thematicAxis: thematicAxis ?? this.thematicAxis,
      skills: skills ?? this.skills,
      thematicUnits: thematicUnits ?? this.thematicUnits,
    );
  }
}
