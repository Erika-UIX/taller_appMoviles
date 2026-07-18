import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AlumnoFormScreen extends StatefulWidget {
  final String? id;
  final String? name;
  final String? enrollment;
  final String? career;
  final bool? isActive;
  const AlumnoFormScreen({
    super.key,
    this.id,
    this.name,
    this.enrollment,
    this.career,
    this.isActive,
  });

  @override
  State<AlumnoFormScreen> createState() => _AlumnoFormScreenState();
}

class _AlumnoFormScreenState extends State<AlumnoFormScreen> {
  // 👇 DECLARAMOS LOS CONTROLLERS PARA LAS CAJAS DE TEXTO
  late TextEditingController _nameController;
  late TextEditingController _enrollmentController;
  late TextEditingController _careerController;

  late bool _isActiveState;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.id != null;
    _isActiveState = widget.isActive ?? true;

    // 👇 INICIALIZAMOS LOS CONTROLLERS CON EL DATO QUE SE ENVÍA (O VACÍO SI ES NUEVO)
    _nameController = TextEditingController(text: widget.name ?? '');
    _enrollmentController = TextEditingController(
      text: widget.enrollment ?? '',
    );
    _careerController = TextEditingController(text: widget.career ?? '');
  }

  // 👇 BUENA PRÁCTICA: DESTRUIR LOS CONTROLLERS AL SALIR DE LA PANTALLA
  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentController.dispose();
    _careerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modificar Alumno' : 'Nuevo Alumno'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing
                  ? 'Actualizar expediente'
                  : 'Registrar nuevo estudiante',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // 👇 LES PASAMOS SU RESPECTIVO CONTROLLER
            CustomInput(
              controller: _nameController,
              label: 'Nombre Completo',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),

            CustomInput(
              controller: _enrollmentController,
              label: 'Número de Matrícula',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            CustomInput(
              controller: _careerController,
              label: 'Carrera',
              icon: Icons.account_tree_outlined,
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Estado del Alumno',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _isActiveState
                      ? 'Activo (Puede registrar materias)'
                      : 'Inactivo',
                ),
                value: _isActiveState,
                activeThumbColor: Theme.of(context).colorScheme.primary,
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                onChanged: (bool value) {
                  setState(() {
                    _isActiveState = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 40),

            Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                return studentProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: _isEditing
                            ? 'GUARDAR CAMBIOS'
                            : 'REGISTRAR ALUMNO',
                        onPressed: () async {
                          if (_nameController.text.trim().isEmpty ||
                              _enrollmentController.text.trim().isEmpty ||
                              _careerController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, llena todos los campos obligatorios',
                                ),
                                backgroundColor: Colors.amber,
                              ),
                            );
                          }

                          bool success = false;

                          if (_isEditing) {
                            success = await studentProvider
                                .updateExistingStudent(
                                  id: widget.id!,
                                  name: _nameController.text.trim(),
                                  enrollment: _enrollmentController.text.trim(),
                                  carreer: _careerController.text.trim(),
                                  isActive: _isActiveState,
                                );
                          } else {
                            success = await studentProvider.registerStudent(
                              name: _nameController.text.trim(),
                              enrollment: _enrollmentController.text.trim(),
                              carreer: _careerController.text.trim(),
                              isActive: _isActiveState,
                            );
                          }

                          if (success) {
                            _nameController.clear();
                            _enrollmentController.clear();
                            _careerController.clear();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isEditing
                                        ? '¡Alumno actualizado exitosamente!'
                                        : '¡Alumno guardado en Firebase exitosamente!',
                                  ),
                                  backgroundColor: Colors.green.shade700,
                                ),
                              );
                              context.pop();
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Hubo un error al conectarse con Firebase cloud',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
