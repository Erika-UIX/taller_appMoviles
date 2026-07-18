import 'package:flutter/material.dart';
import 'package:myapp/models/models.dart';
import 'package:myapp/providers/providers.dart';
import 'package:provider/provider.dart';

class AsignacionScreen extends StatefulWidget {
  const AsignacionScreen({super.key});

  @override
  State<AsignacionScreen> createState() => _AsignacionScreenState();
}

class _AsignacionScreenState extends State<AsignacionScreen> {
  // Estado local para los selectores del cascarón
  StudentModel? _selectedAlumno;
  SubjectModel? _selectedMateria;

  // Claves para forzar el reinicio (reset) de los DropdownMenu visualmente
  UniqueKey _alumnoKey = UniqueKey();
  UniqueKey _materiaKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        context.read<StudentProvider>().listenToStudents();
        context.read<SubjectProvider>().listenToSubjects();
        context
            .read<EnrollmentProvider>()
            .listenToEnrollments(); // Agregamos esta línea <--->
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final subjectProvider = Provider.of<SubjectProvider>(context);

    final themeObject = Theme.of(context);
    final mediaOnject = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Contenedor del Formulario Superior (Card Estilizado)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Vincular Alumno a Materia',
                      style: themeObject.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeObject.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector de Alumno (DropdownMenu de Material 3)
                    DropdownMenu<StudentModel>(
                      key:
                          _alumnoKey, // Llave para resetear el input visualmente
                      width: mediaOnject.size.width - 64,
                      label: const Text('Seleccionar Alumno'),
                      leadingIcon: const Icon(Icons.person_outline_rounded),
                      onSelected: (StudentModel? student) {
                        setState(() => _selectedAlumno = student);
                      },
                      dropdownMenuEntries: studentProvider.students.map((
                        student,
                      ) {
                        return DropdownMenuEntry<StudentModel>(
                          value: student,
                          label: '${student.name} (${student.enrollment})',
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Selector de Materia
                    DropdownMenu<SubjectModel>(
                      key:
                          _materiaKey, // Llave para resetear el input visualmente
                      width: mediaOnject.size.width - 64,
                      label: const Text('Seleccionar Materia'),
                      leadingIcon: const Icon(Icons.book_outlined),
                      onSelected: (SubjectModel? subject) {
                        setState(() => _selectedMateria = subject);
                      },
                      dropdownMenuEntries: subjectProvider.subjects
                          .map<DropdownMenuEntry<SubjectModel>>((subject) {
                            return DropdownMenuEntry<SubjectModel>(
                              value: subject,
                              label: '${subject.name} (${subject.code})',
                            );
                          })
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // Botón de Asignación
                    Consumer<EnrollmentProvider>(
                      builder: (context, enrollmentProvider, child) {
                        return enrollmentProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton.icon(
                                onPressed:
                                    (_selectedAlumno != null &&
                                        _selectedMateria != null)
                                    ? () async {
                                        // Expresión regular sutil para extraer solo el nombre antes del paréntesis
                                        final errorResult =
                                            await enrollmentProvider
                                                .createEnrollment(
                                                  studentId:
                                                      _selectedAlumno!.id!,
                                                  studentName:
                                                      _selectedAlumno!.name,
                                                  subjectId:
                                                      _selectedMateria!.id!,
                                                  subjectName:
                                                      _selectedMateria!.name,
                                                );

                                        if (errorResult != null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(errorResult),
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                          );
                                          return;
                                        }

                                        if (context.mounted) {
                                          if (errorResult != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  errorResult.replaceAll(
                                                    'Exception',
                                                    '',
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.red.shade700,
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Asignación realizada con exito',
                                              ),
                                              backgroundColor:
                                                  Colors.green.shade700,
                                            ),
                                          );

                                          setState(() {
                                            _selectedAlumno = null;
                                            _selectedMateria = null;
                                            _alumnoKey = UniqueKey();
                                            _materiaKey = UniqueKey();
                                          });
                                        }
                                      }
                                    : null,
                                icon: const Icon(Icons.link_rounded),
                                label: const Text('ASIGNAR CURSO'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      themeObject.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Título de la sección inferior
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Text(
              'Últimas Asignaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          // 2. Listado de Asignaciones (Scrollable y Reactivo)
          Expanded(
            child: Consumer<EnrollmentProvider>(
              builder: (context, provider, child) {
                if (provider.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.enrollments.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay asignaciones',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.enrollments.length,
                  itemBuilder: (context, index) {
                    final asignacion = provider.enrollments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.assignment_ind_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        title: Text(
                          asignacion.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Inscrito en: ${asignacion.subjectName}',
                        ),
                        trailing: Text(
                          asignacion.date,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
