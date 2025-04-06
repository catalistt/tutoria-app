import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/data/datasources/firebase/firestore_datasource.dart';
import 'package:tutoria_app/domain/entities/subject_entity.dart';
import 'package:tutoria_app/data/models/subject_model.dart';

// Provider para obtener las métricas de aprendizaje del estudiante
final learningMetricsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Datos de ejemplo - En una implementación real, esto vendría de Firestore
  await Future.delayed(const Duration(seconds: 1));
  
  return {
    'totalStudyTime': 1260, // minutos
    'questionsAnswered': 350,
    'correctAnswers': 280,
    'accuracy': 80.0,
    'streakDays': 12,
    'lastStudyDate': DateTime.now().subtract(const Duration(hours: 2)),
  };
});

// Provider para obtener sugerencias personalizadas de aprendizaje
final learningRecommendationsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    {
      'title': 'Mejora tus Ecuaciones',
      'description': 'Practica problemas de álgebra para reforzar tus habilidades',
      'subject': 'Matemáticas',
      'difficulty': 'Intermedio',
      'recommendedTime': 45,
      'type': 'exercise',
    },
    {
      'title': 'Comprensión de Lectura',
      'description': 'Análisis de textos para mejorar tus habilidades interpretativas',
      'subject': 'Lenguaje',
      'difficulty': 'Avanzado',
      'recommendedTime': 60,
      'type': 'reading',
    },
    {
      'title': 'Fundamentos de Física',
      'description': 'Video explicativo sobre mecánica clásica',
      'subject': 'Física',
      'difficulty': 'Básico',
      'recommendedTime': 30,
      'type': 'video',
    },
  ];
});

// Provider para obtener logros y estadísticas del estudiante
final studentAchievementsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  return {
    'totalBadges': 5,
    'currentLevel': 'Aprendiz Avanzado',
    'badges': [
      {
        'name': 'Matemático Principiante',
        'description': 'Completaste 10 ejercicios de matemáticas',
        'icon': Icons.calculate,
        'color': Colors.blue,
      },
      {
        'name': 'Lector Voraz',
        'description': 'Leíste 5 textos de comprensión',
        'icon': Icons.book,
        'color': Colors.green,
      },
      {
        'name': 'Científico en Desarrollo',
        'description': 'Visualizaste 3 videos de ciencias',
        'icon': Icons.science,
        'color': Colors.purple,
      },
    ],
    'nextLevelProgress': 0.7,
  };
});

// Provider para obtener próximos eventos o recordatorios
final upcomingEventsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  
  return [
    {
      'title': 'Quiz de Matemáticas',
      'description': 'Evaluación de ecuaciones lineales',
      'date': DateTime.now().add(const Duration(days: 3)),
      'type': 'quiz',
      'subject': 'Matemáticas',
    },
    {
      'title': 'Taller de Lectura Crítica',
      'description': 'Mejora tus habilidades de comprensión',
      'date': DateTime.now().add(const Duration(days: 7)),
      'type': 'workshop',
      'subject': 'Lenguaje',
    },
  ];
});