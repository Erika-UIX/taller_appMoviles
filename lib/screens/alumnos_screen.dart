import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AlumnosScreen extends StatefulWidget {
  const AlumnosScreen({super.key});

  @override
  State<AlumnosScreen> createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        context.read<StudentProvider>().listenToStudents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // 1. Buscador Estilo Material 3
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SearchBar(
              hintText: 'Buscar alumno por nombre o matrícula...',
              leading: const Icon(Icons.search_rounded),
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              elevation: const WidgetStatePropertyAll<double>(1.0),
              shape: WidgetStatePropertyAll<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // 2. Chips de Filtrado Rápido Corregidos (onSelected obligatorio)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: true,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Activos'),
                  //backgroundColor: Colors.yellowAccent,
                  selected: false,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Inactivos'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Software'),
                  selected: false,
                  onSelected: (bool selected) {},
                ),
              ],
            ),
          ),

          // 3. Listado Dinámico de Alumnos
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, provider, child) {
                if (provider.isFetchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (provider.students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off_rounded,
                          size: 72,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay alumnos registrados aún',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Presiona el botón "+" para agregar el primero',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 800));
                    return Future.value();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.students.length,
                    itemBuilder: (context, index) {
                      final alumno = provider.students[index];

                      return InkWell(
                        onTap: () {
                          // Pasamos el mapa del alumno mediante el parámetro 'extra'
                          context.go(
                            '/alumnos/editar',
                            extra: {
                              'id': alumno.id,
                              'name': alumno.name,
                              'enrollment': alumno.enrollment,
                              'career': alumno.carreer,
                              'isActive': alumno.isActive,
                            },
                          );
                        },
                        child: StudentCard(
                          name: alumno.name,
                          enrollment: alumno.enrollment,
                          career: alumno.carreer,
                          isActive: alumno.isActive,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/alumnos/nuevo');
        },
        backgroundColor: colorSchema.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
