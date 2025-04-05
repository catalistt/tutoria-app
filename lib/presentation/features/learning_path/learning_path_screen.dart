import 'package:flutter/material.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Ruta de Aprendizaje'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fundamentos de Matemáticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Repaso de conceptos básicos necesarios para avanzar en álgebra.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: const Text('Básico'),
                        backgroundColor: Colors.blue.withOpacity(0.2),
                      ),
                      const Text('30 minutos'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ecuaciones Lineales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aprende a resolver ecuaciones de primer grado y sus aplicaciones.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: const Text('Intermedio'),
                        backgroundColor: Colors.orange.withOpacity(0.2),
                      ),
                      const Text('45 minutos'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}