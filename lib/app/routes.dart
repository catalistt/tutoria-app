import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/core/services/auth_service.dart';
import 'package:tutoria_app/presentation/features/auth/screens/login_screen.dart';
import 'package:tutoria_app/presentation/features/auth/screens/signup_screen.dart';
import 'package:tutoria_app/presentation/features/auth/screens/forgot_password_screen.dart';
import 'package:tutoria_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:tutoria_app/presentation/features/home/screens/home_screen.dart';
import 'package:tutoria_app/presentation/features/learning_path/screens/learning_path_screen.dart';
import 'package:tutoria_app/presentation/features/subject/screens/subject_screen.dart';
import 'package:tutoria_app/presentation/features/chat/screens/chat_screen.dart';

// Provider para el GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Obtener el estado de autenticación del usuario
      final isLoggedIn = authState.value != null;
      
      // Comprobar si el usuario está en una página de autenticación
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      
      // Si no está autenticado y no va a una página de autenticación, redirigir a login
      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth/login';
      }
      
      // Si está autenticado y va a una página de autenticación, redirigir a inicio
      if (isLoggedIn && isGoingToAuth) {
        return '/home';
      }
      
      // En cualquier otro caso, continuar a la ruta solicitada
      return null;
    },
    routes: [
      // Ruta raíz que redirige según el estado de autenticación
      GoRoute(
        path: '/',
        redirect: (_, __) => authState.value != null ? '/home' : '/auth/login',
      ),
      
      // Rutas de autenticación
      GoRoute(
        path: '/auth',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: 'onboarding',
            builder: (context, state) => const OnboardingScreen(),
          ),
        ],
      ),
      
      // Rutas principales
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/learning-path',
        builder: (context, state) => const LearningPathScreen(),
      ),
      GoRoute(
        path: '/subject/:subjectId',
        builder: (context, state) => SubjectScreen(
          subjectId: state.pathParameters['subjectId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/chat/:questionId',
        builder: (context, state) => ChatScreen(
          questionId: state.pathParameters['questionId'],
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
