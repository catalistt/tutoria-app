import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutoria_app/app/theme.dart';
import 'package:tutoria_app/app/routes.dart';
import 'package:tutoria_app/core/services/auth_service.dart';

class TutoriaApp extends ConsumerWidget {
  const TutoriaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    
    return MaterialApp.router(
      title: 'TutorIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Puedes cambiarlo a un provider si quieres tema dinámico
      routerConfig: goRouter,
    );
  }
}
