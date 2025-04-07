import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutoria_app/app/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tutoria_app/domain/entities/subject-entity.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final String subjectId;
  
  const SubjectDetailScreen({
    Key? key,
    required this.subjectId,
  }) : super(key: key);
  
  @override
  ConsumerState<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // En una implementación real, se obtendría la información de la materia desde un provider
    // final subject = ref.watch(subjectProvider(widget.subjectId));
    
    // Por ahora, usamos datos de ejemplo
    final subject = SubjectEntity(
      id: widget.subjectId,
      name: "Matemáticas",
      description: "Álgebra, geometría, aritmética y más",
      imageUrl: "https://via.placeholder.com/150?text=Matemáticas",
      order: 1,
      isActive: true,
    );
    
    // Datos de estadísticas (simulados)
    final stats = {
      "progress": 0.68,
      "exercises": 24,
      "completed": 16,
      "streak": 5,
    };
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, subject),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(context, stats),
                  _buildExercisesTab(context),
                  _buildResourcesTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, SubjectEntity subject) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 22,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calculate,
                    size: 32,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subject.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: "Resumen"),
          Tab(text: "Ejercicios"),
          Tab(text: "Recursos"),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab(BuildContext context, Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard(context, stats),
          const SizedBox(height: 24),
          const Text(
            "Rutas de Aprendizaje",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildLearningPathCard(
            title: "Ruta TutorIA",
            description: "Esta ruta está completamente personalizada para ti. Cada pregunta está pensada en mejorar tus conocimientos y habilidades.",
            icon: Icons.route,
            color: AppTheme.secondaryColor,
            progress: 0.65,
          ),
          const SizedBox(height: 16),
          _buildLearningPathCard(
            title: "Práctica Libre",
            description: "Elige la materia, ejercicios y dificultad que quieras. Practica a tu ritmo.",
            icon: Icons.lightbulb_outline,
            color: Colors.orange,
            progress: 0.25,
          ),
          const SizedBox(height: 16),
          _buildLearningPathCard(
            title: "Ensayo PAES",
            description: "¡Prepárate para la PAES con ejercicios tipo examen!",
            icon: Icons.school,
            color: Colors.purple,
            progress: 0.4,
          ),
          const SizedBox(height: 24),
          const Text(
            "Recomendaciones",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            title: "Ecuaciones lineales",
            description: "Continúa con este módulo para mejorar tu comprensión de ecuaciones.",
            icon: Icons.timeline,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            title: "Geometría: Áreas y perímetros",
            description: "Esta es una de tus áreas con mayor oportunidad de mejora.",
            icon: Icons.category,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressCard(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tu progreso",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 10.0,
                  percent: stats["progress"] as double,
                  center: Text(
                    "${((stats["progress"] as double) * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  progressColor: AppTheme.primaryColor,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatRow(
                        "Ejercicios totales:",
                        "${stats["exercises"]}",
                        Icons.assignment,
                      ),
                      const SizedBox(height: 8),
                      _buildStatRow(
                        "Completados:",
                        "${stats["completed"]}",
                        Icons.check_circle,
                      ),
                      const SizedBox(height: 8),
                      _buildStatRow(
                        "Racha actual:",
                        "${stats["streak"]} días",
                        Icons.local_fire_department,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildLearningPathCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                borderRadius: BorderRadius.circular(4),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                "${(progress * 100).toInt()}% completado",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecommendationCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildExercisesTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ejercicios recientes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final exercises = [
                        {
                          "title": "Ecuaciones lineales",
                          "type": "Algebra",
                          "score": "8/10",
                          "date": "Hoy",
                        },
                        {
                          "title": "Funciones cuadráticas",
                          "type": "Algebra",
                          "score": "7/10",
                          "date": "Ayer",
                        },
                        {
                          "title": "Geometría plana",
                          "type": "Geometría",
                          "score": "9/10",
                          "date": "Hace 3 días",
                        },
                      ];
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          exercises[index]["title"] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "${exercises[index]["type"]} • ${exercises[index]["date"]}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            exercises[index]["score"] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Categorías",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildCategoryCard(
                  title: "Álgebra",
                  count: 24,
                  icon: Icons.functions,
                  color: Colors.blue,
                ),
                _buildCategoryCard(
                  title: "Geometría",
                  count: 18,
                  icon: Icons.category,
                  color: Colors.orange,
                ),
                _buildCategoryCard(
                  title: "Aritmética",
                  count: 16,
                  icon: Icons.calculate,
                  color: Colors.green,
                ),
                _buildCategoryCard(
                  title: "Estadística",
                  count: 12,
                  icon: Icons.bar_chart,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$count ejercicios",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildResourcesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Material de estudio",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              final resources = [
                {
                  "title": "Fundamentos de álgebra",
                  "type": "PDF",
                  "size": "2.4 MB",
                  "icon": Icons.picture_as_pdf,
                  "color": Colors.red,
                },
                {
                  "title": "Videoconferencia: Ecuaciones",
                  "type": "VIDEO",
                  "size": "45 min",
                  "icon": Icons.video_library,
                  "color": Colors.blue,
                },
                {
                  "title": "Resumen de fórmulas",
                  "type": "PDF",
                  "size": "1.2 MB",
                  "icon": Icons.picture_as_pdf,
                  "color": Colors.red,
                },
                {
                  "title": "Presentación: Geometría",
                  "type": "PPT",
                  "size": "5.8 MB",
                  "icon": Icons.slideshow,
                  "color": Colors.orange,
                },
                {
                  "title": "Audio-explicación: Funciones",
                  "type": "AUDIO",
                  "size": "22 min",
                  "icon": Icons.audiotrack,
                  "color": Colors.green,
                },
              ];
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (resources[index]["color"] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      resources[index]["icon"] as IconData,
                      color: resources[index]["color"] as Color,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    resources[index]["title"] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "${resources[index]["type"]} • ${resources[index]["size"]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Recursos externos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enlaces útiles",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLinkItem(
                    title: "Khan Academy - Matemáticas",
                    icon: Icons.public,
                    color: Colors.green,
                  ),
                  _buildLinkItem(
                    title: "YouTube - Canal de Matemáticas",
                    icon: Icons.video_library,
                    color: Colors.red,
                  ),
                  _buildLinkItem(
                    title: "Biblioteca de ejercicios",
                    icon: Icons.book,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLinkItem({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}