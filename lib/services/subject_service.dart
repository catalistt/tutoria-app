import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/models/subject.dart';

// Datos de ejemplo
final subjectsData = [
  Subject(
    id: 'math',
    name: 'Matemáticas',
    description: 'Álgebra, geometría, aritmética y más',
    imageUrl: 'https://via.placeholder.com/150?text=Matematicas',
    order: 1,
    isActive: true,
  ),
  Subject(
    id: 'language',
    name: 'Lenguaje',
    description: 'Comprensión lectora, gramática y comunicación',
    imageUrl: 'https://via.placeholder.com/150?text=Lenguaje',
    order: 2,
    isActive: true,
  ),
  Subject(
    id: 'science',
    name: 'Ciencias',
    description: 'Biología, química y física',
    imageUrl: 'https://via.placeholder.com/150?text=Ciencias',
    order: 3,
    isActive: true,
  ),
  Subject(
    id: 'history',
    name: 'Historia',
    description: 'Historia de Chile y del mundo',
    imageUrl: 'https://via.placeholder.com/150?text=Historia',
    order: 4,
    isActive: true,
  ),
  Subject(
    id: 'english',
    name: 'Inglés',
    description: 'Inglés básico, intermedio y avanzado',
    imageUrl: 'https://via.placeholder.com/150?text=Inglés',
    order: 5,
    isActive: true,
  ),
];

// Provider para las materias
final subjectsProvider = FutureProvider<List<Subject>>((ref) async {
  // Simulamos una carga de datos con un delay
  await Future.delayed(const Duration(seconds: 1));
  return subjectsData;
});

// Provider para obtener una materia específica por ID
final subjectProvider = FutureProvider.family<Subject?, String>((ref, id) async {
  final subjects = await ref.watch(subjectsProvider.future);
  return subjects.firstWhere((subject) => subject.id == id, orElse: () => throw Exception('Materia no encontrada'));
});