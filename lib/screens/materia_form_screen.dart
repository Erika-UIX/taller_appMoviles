import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/providers.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MateriaFormScreen extends StatefulWidget {
  final String? id;
  final String? code;
  final String? name;
  final int? credits;
  final String? department;

  const MateriaFormScreen({
    super.key,
    this.id,
    this.code,
    this.name,
    this.credits,
    this.department,
  });

  @override
  State<MateriaFormScreen> createState() => _MateriaFormScreenState();
}

class _MateriaFormScreenState extends State<MateriaFormScreen> {
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _departmentController;

  late double _currentCredits;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.id != null;

    _codeController = TextEditingController(text: widget.code ?? '');
    _nameController = TextEditingController(text: widget.name ?? '');
    _departmentController = TextEditingController(
      text: widget.department ?? '',
    );

    // Si viene un crédito inicial lo asignamos, si no arranca en 3 por defecto
    _currentCredits = (widget.credits ?? 3).toDouble();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modificar Materia' : 'Nueva Materia'),
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
                  ? 'Actualizar detalles de la asignatura'
                  : 'Crear nueva asignatura académica',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            CustomInput(
              controller: _codeController,
              label: 'Código de Materia (Ej: SW-401)',
              icon: Icons.qr_code_rounded,
            ),
            const SizedBox(height: 16),

            CustomInput(
              controller: _nameController,
              label: 'Nombre de la Asignatura',
              icon: Icons.book_outlined,
            ),
            const SizedBox(height: 16),

            CustomInput(
              controller: _departmentController,
              label: 'Área / Departamento',
              icon: Icons.lan_outlined,
            ),
            const SizedBox(height: 24),

            // Selector interactivo de Créditos / UV
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Créditos Académicos (UV)',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${_currentCredits.toInt()}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _currentCredits,
                      min: 1,
                      max: 6,
                      divisions: 5,
                      label: _currentCredits.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentCredits = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            Consumer<SubjectProvider>(
              builder: (context, subjectProvider, child) {
                return subjectProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: _isEditing ? 'GUARDAR CAMBIOS' : 'CREAR MATERIA',
                        onPressed: () async {
                          if (_codeController.text.isEmpty ||
                              _nameController.text.isEmpty ||
                              _departmentController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, completa todos los campos del formulario',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );

                            return;
                          }

                          bool success = false;

                          if (_isEditing) {
                            success = await subjectProvider
                                .updateExistingSubject(
                                  id: widget.id!,
                                  code: _codeController.text,
                                  name: _nameController.text,
                                  credits: _currentCredits.toInt(),
                                  department: _departmentController.text,
                                );
                          } else {
                            success = await subjectProvider.registerSubject(
                              code: _codeController.text,
                              name: _nameController.text,
                              credits: _currentCredits.toInt(),
                              department: _departmentController.text,
                            );
                          }

                          if (success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isEditing
                                        ? 'Materia actualizada exitosamente'
                                        : 'Materia creada exitosamente',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              context.pop();
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Ocurrió un error al guardar la materia. Intenta nuevamente.',
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
