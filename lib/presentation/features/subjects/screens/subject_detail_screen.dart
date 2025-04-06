import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/services/subject_service.dart';

class SubjectDetailScreen extends ConsumerWidget {
  final String subjectId;
  
  const SubjectDetailScreen({
    Key? key,
    required this.subjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectAsync = ref.watch(subjectProvider(subjectId));
    
    return Scaffold(
      body: subjectAsync.when(
        data: (subject) {
          if (subject == null) {
            return const Center(
              child: Text('Materia no encontrada'),
            );
          }
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.green.shade300,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(subject.name),
                  background: Container(
                    color: Colors.green.shade100,
                    child: const Center(
                      child: Icon(
                        Icons.school,
                        size: 80,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(subject.description),
                      const SizedBox(height: 24),
                      const Text(
                        'Contenidos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildContentItem(
                        context, 
                        'Introducción', 
                        'Conceptos básicos y fundamentos',
                        Icons.play_circle,
                        Colors.blue,
                      ),
                      _buildContentItem(
                        context, 
                        'Teoría', 
                        'Principios teóricos fundamentales',
                        Icons.menu_book,
                        Colors.purple,
                      ),
                      _buildContentItem(
                        context, 
                        'Ejercicios', 
                        'Práctica y aplicación de conceptos',
                        Icons.assignment,
                        Colors.teal,
                      ),
                      _buildContentItem(
                        context, 
                        'Evaluación', 
                        'Prueba de conocimientos',
                        Icons.quiz,
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.green,
        icon: const Icon(Icons.message),
        label: const Text('Preguntar a TutorIA'),
      ),
    );
  }
  
  Widget _buildContentItem(
    BuildContext context, 
    String title, 
    String description, 
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}