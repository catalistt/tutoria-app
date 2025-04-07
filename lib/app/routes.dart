import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/presentation/features/auth/screens/login_screen.dart';
import 'package:tutoria_app/presentation/features/auth/screens/signup_screen.dart';
import 'package:tutoria_app/presentation/features/home/screens/home_screen.dart';
import 'package:tutoria_app/services/auth_service.dart';
import 'package:tutoria_app/presentation/features/subject/screens/subject_detail_screen.dart';

// Provider para el GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Si no está autenticado y no va a una ruta de autenticación, redirigir a login
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      
      if (!isAuthenticated && !isAuthRoute && state.matchedLocation != '/') {
        return '/login';
      }
      
      // Si está autenticado y va a una ruta de autenticación, redirigir a home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Pantalla principal
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      GoRoute(
        path: '/subject/:subjectId',
        builder: (context, state) => SubjectDetailScreen(
          subjectId: state.pathParameters['subjectId']!,
        ),
      ),

      // Rutas de autenticación
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Rutas protegidas
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});

// Pantalla de bienvenida
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TutorIA'),
        backgroundColor: Colors.green.shade300,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a TutorIA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Plataforma de aprendizaje personalizado con IA',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}