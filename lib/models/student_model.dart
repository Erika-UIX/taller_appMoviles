class StudentModel {
  final String? id;
  final String name;
  final String enrollment;
  final String carreer;
  final bool isActive;

  StudentModel({
    this.id,
    required this.name,
    required this.enrollment,
    required this.carreer,
    required this.isActive,
  });

  // convierte un objeto StudentModel a un Map de JSON para enviar a Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'enrollment': enrollment,
      'carreer': carreer,
      'isActive': isActive,
    };
  }

  // Crea un studentModel a partir de un documento recibido de Firebase
  factory StudentModel.fromFirestore(String id, Map<String, dynamic> data) {
    return StudentModel(
      id: id,
      name: data['name'],
      enrollment: data['enrollment'],
      carreer: data['carreer'],
      isActive: data['isActive'],
    );
  }
}
