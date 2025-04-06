import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/models/user.dart';

// Estado de autenticación
class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;
  
  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

// Proveedor del estado de autenticación
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Notificador que maneja los cambios de estado
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());
  
  // Simular inicio de sesión
  Future<bool> signIn(String email, String password) async {
    try {
      // Simulando una llamada a la API
      await Future.delayed(const Duration(seconds: 1));
      
      // Validación básica
      if (email.isEmpty || password.isEmpty) {
        state = state.copyWith(errorMessage: 'Correo o contraseña no pueden estar vacíos');
        return false;
      }
      
      // Simulamos credenciales correctas
      if (email == 'test@ejemplo.com' && password == 'password') {
        final user = User(
          id: '1',
          name: 'Usuario de Prueba',
          email: email,
          grade: 'Segundo medio',
          educationalGoal: 'Mejorar mis notas',
        );
        
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          errorMessage: null,
        );
        return true;
      }
      
      // Credenciales incorrectas
      state = state.copyWith(errorMessage: 'Correo o contraseña incorrectos');
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error al iniciar sesión: $e');
      return false;
    }
  }
  
  // Simular registro
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String grade,
    required String educationalGoal,
  }) async {
    try {
      // Simulando una llamada a la API
      await Future.delayed(const Duration(seconds: 1));
      
      // Validación básica
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        state = state.copyWith(errorMessage: 'Todos los campos son obligatorios');
        return false;
      }
      
      // Simulando registro exitoso
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        grade: grade,
        educationalGoal: educationalGoal,
      );
      
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        errorMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error al registrar: $e');
      return false;
    }
  }
  
  // Cerrar sesión
  void signOut() {
    state = AuthState();
  }
}