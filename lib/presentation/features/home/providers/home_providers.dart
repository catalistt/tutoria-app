import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/data/datasources/firebase/firestore_datasource.dart';
import 'package:tutoria_app/domain/entities/subject_entity.dart';
import 'package:tutoria_app/data/models/subject_model.dart';

// Provider para obtener las materias del usuario
final subjectsProvider = FutureProvider<List<SubjectEntity>>((ref) async {
  try {
    final firestoreService = ref.watch(firestoreServiceProvider);
    
    // Obtener las materias de Firestore
    final subjectsData = await firestoreService.getCollection(
      collection: 'subjects',
      orderBy: 'order',
    );
    
    // Convertir a modelos y luego a entidades
    return subjectsData
        .map((data) => SubjectModel.fromMap(data).toEntity())
        .toList();
  } catch (e) {
    // En caso de error, devolver lista vacía
    return [];
  }
});

// Provider para obtener las actividades recientes del usuario
final recentActivitiesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Para propósitos de demostración, generamos actividades de ejemplo
  // En una implementación real, esto debería obtenerse de Firestore
  await Future.delayed(const Duration(seconds: 1)); // Simular carga de datos
  
  return [
    {
      'title': 'Matemáticas - Ecuaciones',
      'subtitle': 'Completaste 5 ejercicios',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'type': 'exercise',
      'progress': 0.8,
    },
    {
      'title': 'Física - Cinemática',
      'subtitle': 'Video de introducción',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'video',
      'progress': 1.0,
    },
    {
      'title': 'Lenguaje - Comprensión Lectora',
      'subtitle': 'Comenzaste un cuestionario',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'quiz',
      'progress': 0.3,
    },
  ];
});

// Provider para obtener las estadísticas de aprendizaje del usuario
final learningStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Para propósitos de demostración, generamos estadísticas de ejemplo
  await Future.delayed(const Duration(seconds: 1)); // Simular carga de datos
  
  return {
    'totalStudyTime': 1260, // minutos
    'questionsAnswered': 35,
    'correctAnswers': 28,
    'accuracy': 80.0,
    'streakDays': 5,
    'lastStudyDate': DateTime.now().subtract(const Duration(hours: 2)),
  };
});
