// Archivo: lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';  // Solo si implementas Google Sign In
import 'package:tutoria_app/data/datasources/firebase/firestore_datasource.dart';
import 'package:tutoria_app/data/models/user_model.dart';

// Provider para el estado de autenticación
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider para el servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

// Provider para el usuario actual
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      
      final userData = await firestoreService.getDocument(
        collection: 'users',
        documentId: user.uid,
      );
      
      if (userData != null) {
        return UserModel.fromMap({...userData, 'id': user.uid});
      }
      
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

class AuthService {
  final ProviderRef _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();  // Solo si implementas Google Sign In
  
  AuthService(this._ref);
  
  // Email/Password Sign In
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Actualizar la fecha de último inicio de sesión
      if (credential.user != null) {
        await _ref.read(firestoreServiceProvider).updateDocument(
          collection: 'users',
          documentId: credential.user!.uid,
          data: {'lastLoginAt': DateTime.now()},
        );
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Registro con Email/Password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String grade,
    required String educationalGoal,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Crear documento de usuario en Firestore
      final user = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        grade: grade,
        educationalGoal: educationalGoal,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        profileImageUrl: null,
        role: 'student',  // Rol por defecto
      );
      
      await _ref.read(firestoreServiceProvider).setDocument(
        collection: 'users',
        documentId: user.id,
        data: user.toMap(),
      );
      
      // Actualizar el displayName en Firebase Auth
      await credential.user!.updateDisplayName(name);
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Google Sign In (opcional)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;
      
      // Obtener detalles de autenticación de la solicitud
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Crear credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Iniciar sesión con credencial
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Si es un nuevo usuario, crear perfil en Firestore
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final user = UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user?.displayName ?? 'Usuario',
          email: userCredential.user?.email ?? '',
          grade: 'No especificado',  // Valores por defecto que el usuario actualizará después
          educationalGoal: 'No especificado',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          profileImageUrl: userCredential.user?.photoURL,
          role: 'student',
        );
        
        await _ref.read(firestoreServiceProvider).setDocument(
          collection: 'users',
          documentId: user.id,
          data: user.toMap(),
        );
      } else {
        // Actualizar fecha de último inicio de sesión
        await _ref.read(firestoreServiceProvider).updateDocument(
          collection: 'users',
          documentId: userCredential.user!.uid,
          data: {'lastLoginAt': DateTime.now()},
        );
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }
  
  // Recuperación de contraseña
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();  // Solo si implementas Google Sign In
    await _auth.signOut();
  }
  
  // Actualizar perfil de usuario
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? grade,
    String? educationalGoal,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      
      if (name != null) updates['name'] = name;
      if (grade != null) updates['grade'] = grade;
      if (educationalGoal != null) updates['educationalGoal'] = educationalGoal;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      
      await _ref.read(firestoreServiceProvider).updateDocument(
        collection: 'users',
        documentId: userId,
        data: updates,
      );
      
      // Actualizar también en Auth si cambió el nombre
      if (name != null) {
        await _auth.currentUser?.updateDisplayName(name);
      }
      
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }
  
  // Cambiar contraseña
  Future<void> updatePassword({required String newPassword}) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Manejar excepciones de autenticación con mensajes personalizados
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No existe un usuario con este correo electrónico.');
      case 'wrong-password':
        return Exception('Contraseña incorrecta.');
      case 'email-already-in-use':
        return Exception('Este correo electrónico ya está en uso.');
      case 'weak-password':
        return Exception('La contraseña es demasiado débil.');
      case 'invalid-email':
        return Exception('El formato del correo electrónico no es válido.');
      case 'operation-not-allowed':
        return Exception('Operación no permitida.');
      case 'user-disabled':
        return Exception('Esta cuenta de usuario ha sido deshabilitada.');
      case 'too-many-requests':
        return Exception('Demasiados intentos fallidos. Inténtalo más tarde.');
      case 'requires-recent-login':
        return Exception('Esta operación es sensible y requiere autenticación reciente. Inicia sesión nuevamente antes de volver a intentarlo.');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }
}