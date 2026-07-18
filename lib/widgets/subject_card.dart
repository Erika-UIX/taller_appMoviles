import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String code;
  final String name;
  final int credits;
  final String department;

  const SubjectCard({
    super.key,
    required this.code,
    required this.name,
    required this.credits,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    IconData getDepartmentIcon() {
      final dep = department.toLowerCase();

      if (dep.contains('software') || dep.contains('programación')) {
        return Icons.code_rounded;
      } else if (dep.contains('redes') || dep.contains('telecom')) {
        return Icons.router_rounded;
      } else if (dep.contains('seguridad')) {
        return Icons.security_rounded;
      } else if (dep.contains('diseño')) {
        return Icons.palette_rounded;
      }
      return Icons.book_rounded;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            getDepartmentIcon(),
            color: Theme.of(context).colorScheme.primary,
            size: 26,
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
                'Código: $code',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                'Área: $department',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$credits UV', // Unidades Valorativas / Créditos
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
