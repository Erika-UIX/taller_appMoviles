import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String enrollment;
  final String career;
  final bool isActive;

  const StudentCard({
    super.key,
    required this.name,
    required this.enrollment,
    required this.career,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split('')
        .take(2)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            initials,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Matricula: $enrollment',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                'Carrera: $career',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isActive ? 'Activo' : 'Inactivo',
            style: TextStyle(
              color: isActive ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
