import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/core/services/auth_service.dart';
import 'package:tutoria_app/presentation/common_widgets/custom_button.dart';
import 'package:tutoria_app/presentation/common_widgets/custom_text_field.dart';
import 'package:tutoria_app/presentation/common_widgets/loading_indicator.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedGrade = 'Primero medio';
  String _selectedGoal = 'Mejorar mis notas';
  
  bool _isLoading = false;
  String? _errorMessage;
  
  final List<String> _grades = [
    'Octavo básico',
    'Primero medio',
    'Segundo medio',
    'Tercero medio',
    'Cuarto medio',
    'Preparación PAES',
  ];
  
  final List<String> _goals = [
    'Mejorar mis notas',
    'Preparar pruebas',
    'Preparar la PAES',
    'Reforzar contenidos',
    'Aprender nuevos temas',
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      await ref.read(authServiceProvider).createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        grade: _selectedGrade,
        educationalGoal: _selectedGoal,
      );
      
      // Redirigir al onboarding o a la pantalla principal
      if (mounted) {
        context.go('/auth/onboarding');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    'Únete a TutorIA',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtítulo
                  Text(
                    'Completa los siguientes campos para comenzar',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Nombre
                        CustomTextField(
                          controller: _nameController,
                          label: 'Nombre',
                          hintText: 'Ingresa tu nombre',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          label: 'Correo electrónico',
                          hintText: 'Ingresa tu correo',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Curso
                        DropdownButtonFormField<String>(
                          value: _selectedGrade,
                          decoration: InputDecoration(
                            labelText: 'Curso',
                            prefixIcon: const Icon(Icons.school_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _grades.map((grade) {
                            return DropdownMenuItem<String>(
                              value: grade,
                              child: Text(grade),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGrade = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Objetivo
                        DropdownButtonFormField<String>(
                          value: _selectedGoal,
                          decoration: InputDecoration(
                            labelText: 'Objetivo educativo',
                            prefixIcon: const Icon(Icons.flag_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _goals.map((goal) {
                            return DropdownMenuItem<String>(
                              value: goal,
                              child: Text(goal),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGoal = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Contraseña
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Contraseña',
                          hintText: 'Crea tu contraseña',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Confirmar contraseña
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirmar contraseña',
                          hintText: 'Confirma tu contraseña',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Mensaje de error
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        
                        // Botón de registro
                        _isLoading
                            ? const LoadingIndicator()
                            : CustomButton(
                                text: 'Crear cuenta',
                                onPressed: _register,
                              ),
                        const SizedBox(height: 24),
                        
                        // Iniciar sesión
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('¿Ya tienes una cuenta?'),
                            TextButton(
                              onPressed: () => context.push('/auth/login'),
                              child: const Text('Inicia sesión'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
