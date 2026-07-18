import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MateriasScreen extends StatefulWidget {
  const MateriasScreen({super.key});

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (mounted) {
        context.read<SubjectProvider>().listenToSubjects();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Buscador Estilo Material 3
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SearchBar(
              hintText: 'Buscar materia por nombre o código...',
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

          // 2. Chips de Filtrado (Con la firma correcta exigida por tu Flutter)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todas'),
                  selected: true,
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Software'),
                  selected: false,
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Redes'),
                  selected: false,
                  onSelected: (val) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Ciberseguridad'),
                  selected: false,
                  onSelected: (val) {},
                ),
              ],
            ),
          ),

          // 3. Listado de Materias reactivo al toque
          Expanded(
            child: Consumer<SubjectProvider>(
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

                if (provider.subjects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_rounded,
                          size: 72,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay materias registradas aún.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Presiona el botón "+" para agregar la primera asignatura.',
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
                    itemCount: provider.subjects.length,
                    itemBuilder: (context, index) {
                      final materia = provider.subjects[index];
                      return InkWell(
                        onTap: () {
                          context.go(
                            '/materias/editar',
                            extra: {
                              'id': materia.id,
                              'code': materia.code,
                              'name': materia.name,
                              'credits': materia.credits,
                              'department': materia.department,
                            },
                          );
                        },
                        child: SubjectCard(
                          code: materia.code,
                          name: materia.name,
                          credits: materia.credits,
                          department: materia.department,
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
      // 4. Botón flotante para agregar materia
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/materias/nuevo');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
