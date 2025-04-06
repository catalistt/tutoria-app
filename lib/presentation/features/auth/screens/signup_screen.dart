// lib/presentation/features/auth/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/services/auth_service.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedGrade = 'Primero medio';
  String _selectedGoal = 'Mejorar mis notas';
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _register() async {
    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    final success = await ref.read(authStateProvider.notifier).signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      grade: _selectedGrade,
      educationalGoal: _selectedGoal,
    );
    
    setState(() {
      _isLoading = false;
    });
    
    if (success && mounted) {
      context.go('/home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
        backgroundColor: Colors.green.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Crear una cuenta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Curso',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.school),
              ),
              value: _selectedGrade,
              items: const [
                DropdownMenuItem(value: 'Primero medio', child: Text('Primero medio')),
                DropdownMenuItem(value: 'Segundo medio', child: Text('Segundo medio')),
                DropdownMenuItem(value: 'Tercero medio', child: Text('Tercero medio')),
                DropdownMenuItem(value: 'Cuarto medio', child: Text('Cuarto medio')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGrade = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Objetivo educativo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.lightbulb),
              ),
              value: _selectedGoal,
              items: const [
                DropdownMenuItem(value: 'Mejorar mis notas', child: Text('Mejorar mis notas')),
                DropdownMenuItem(value: 'Preparar pruebas', child: Text('Preparar pruebas')),
                DropdownMenuItem(value: 'Reforzar contenidos', child: Text('Reforzar contenidos')),
                DropdownMenuItem(value: 'Aprender nuevos temas', child: Text('Aprender nuevos temas')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedGoal = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            if (authState.errorMessage != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  authState.errorMessage!,
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrarse'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes una cuenta?'),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Inicia sesión'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}