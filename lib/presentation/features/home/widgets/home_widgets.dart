import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// WelcomeBanner - Banner de bienvenida personalizado
class WelcomeBanner extends StatelessWidget {
  final String message;

  const WelcomeBanner({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// SubjectCard - Tarjeta para materias
class SubjectCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.school,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// RecentActivityCard - Tarjeta para actividades recientes
class RecentActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final String type;
  final double progress;
  final VoidCallback onTap;

  const RecentActivityCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.type,
    required this.progress,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}% completado',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color color;

    switch (type) {
      case 'video':
        iconData = Icons.play_circle_outline;
        color = Colors.red;
        break;
      case 'quiz':
        iconData = Icons.quiz_outlined;
        color = Colors.orange;
        break;
      case 'exercise':
        iconData = Icons.assignment_outlined;
        color = Colors.blue;
        break;
      case 'reading':
        iconData = Icons.menu_book_outlined;
        color = Colors.purple;
        break;
      default:
        iconData = Icons.school_outlined;
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: color,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy, ${DateFormat.Hm().format(date)}';
    } else if (difference.inDays == 1) {
      return 'Ayer, ${DateFormat.Hm().format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(date);
    } else {
      return DateFormat.MMMd().format(date);
    }
  }
}
