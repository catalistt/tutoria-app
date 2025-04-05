import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          _buildPage(
            context,
            title: 'Bienvenido a TutorIA',
            description: 'Plataforma de aprendizaje personalizado con Inteligencia Artificial',
            image: Icons.school,
            color: Colors.blue,
          ),
          _buildPage(
            context,
            title: 'Contenido Personalizado',
            description: 'Aprende a tu ritmo con contenido adaptado a tus necesidades',
            image: Icons.person,
            color: Colors.green,
          ),
          _buildPage(
            context,
            title: 'Comienza Ahora',
            description: 'Estás listo para empezar tu viaje de aprendizaje',
            image: Icons.play_arrow,
            color: Colors.orange,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String title,
    required String description,
    required IconData image,
    required Color color,
    bool isLast = false,
  }) {
    return Container(
      color: color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            image,
            size: 120,
            color: color,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 60),
          if (isLast)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Comenzar'),
            ),
        ],
      ),
    );
  }
}