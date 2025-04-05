import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/core/services/auth_service.dart';
import 'package:tutoria_app/data/datasources/api/deepseek_service.dart';
import 'package:tutoria_app/presentation/common_widgets/custom_widgets.dart';
import 'package:tutoria_app/presentation/features/home/widgets/subject_card.dart';
import 'package:tutoria_app/presentation/features/home/widgets/welcome_banner.dart';
import 'package:tutoria_app/presentation/features/home/widgets/recent_activity_card.dart';
import 'package:tutoria_app/presentation/features/home/providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = true;
  String? _welcomeMessage;
  
  @override
  void initState() {
    super.initState();
    _loadWelcomeMessage();
  }
  
  Future<void> _loadWelcomeMessage() async {
    final user = await ref.read(currentUserProvider.future);
    
    if (user != null) {
      final message = await ref.read(deepseekServiceProvider).generateWelcomeMessage(
        studentName: user.name,
        grade: user.grade,
        educationalGoal: user.educationalGoal,
      );
      
      if (mounted) {
        setState(() {
          _welcomeMessage = message;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _welcomeMessage = "¡Bienvenido a TutorIA! Estamos aquí para ayudarte a aprender de manera personalizada.";
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectsProvider);
    final recentActivities = ref.watch(recentActivitiesProvider);
    final user = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TutorIA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar pantalla de notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implementar pantalla de perfil
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  user.when(
                    data: (userData) => userData != null
                        ? Text(
                            userData.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )
                        : const Text('Usuario'),
                    loading: () => const Text('Cargando...'),
                    error: (_, __) => const Text('Error'),
                  ),
                  user.when(
                    data: (userData) => userData != null
                        ? Text(
                            userData.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        : const Text('email@ejemplo.com'),
                    loading: () => const Text(''),
                    error: (_, __) => const Text(''),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.route_outlined),
              title: const Text('Mi ruta de aprendizaje'),
              onTap: () {
                Navigator.pop(context);
                context.push('/learning-path');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Chat con TutorIA'),
              onTap: () {
                Navigator.pop(context);
                context.push('/chat');
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined),
              title: const Text('Estadísticas'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar pantalla de estadísticas
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar pantalla de configuración
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  context.go('/auth/login');
                }
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                // Recargar datos
                ref.invalidate(subjectsProvider);
                ref.invalidate(recentActivitiesProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WelcomeBanner(message: _welcomeMessage!),
                      const SizedBox(height: 24),
                      
                      const SectionTitle(
                        title: 'Tus materias',
                        subtitle: 'Continúa desde donde lo dejaste',
                      ),
                      
                      subjects.when(
                        data: (data) {
                          if (data.isEmpty) {
                            return const EmptyState(
                              title: 'Sin materias',
                              message: 'No tienes materias disponibles en este momento.',
                              icon: Icons.school_outlined,
                            );
                          }
                          
                          return SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final subject = data[index];
                                return SubjectCard(
                                  name: subject.name,
                                  imageUrl: subject.imageUrl,
                                  onTap: () {
                                    context.push('/subject/${subject.id}');
                                  },
                                );
                              },
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: LoadingIndicator(),
                        ),
                        error: (error, _) => ErrorMessage(
                          message: 'Error al cargar materias: $error',
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const SectionTitle(
                        title: 'Actividad reciente',
                        subtitle: 'Tus últimas sesiones de estudio',
                        onMorePressed: null, // TODO: Implementar pantalla de historial completo
                      ),
                      
                      recentActivities.when(
                        data: (data) {
                          if (data.isEmpty) {
                            return const EmptyState(
                              title: 'Sin actividad reciente',
                              message: 'No has realizado actividades recientemente. ¡Comienza a estudiar!',
                              icon: Icons.history_outlined,
                            );
                          }
                          
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length > 3 ? 3 : data.length,
                            itemBuilder: (context, index) {
                              final activity = data[index];
                              return RecentActivityCard(
                                title: activity['title'],
                                subtitle: activity['subtitle'],
                                date: activity['date'],
                                type: activity['type'],
                                progress: activity['progress'],
                                onTap: () {
                                  // TODO: Navegar a la actividad correspondiente
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: LoadingIndicator(),
                        ),
                        error: (error, _) => ErrorMessage(
                          message: 'Error al cargar actividades: $error',
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Tienes alguna duda?',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pregúntale a TutorIA sobre cualquier tema y recibe ayuda instantánea.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Chatear con TutorIA',
                              onPressed: () {
                                context.push('/chat');
                              },
                              icon: Icons.chat_outlined,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
