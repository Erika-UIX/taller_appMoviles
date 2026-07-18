import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/models.dart';

class StudentRepository {
  final CollectionReference _studentsCollection = FirebaseFirestore.instance
      .collection('students');

  Future<void> addStudent(StudentModel student) async {
    try {
      await _studentsCollection.add(student.toFirestore());
    } catch (e) {
      throw Exception('Error al guardar en Firebase: $e');
    }
  }

  Stream<List<StudentModel>> getStudentsStream() {
    return _studentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return StudentModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> updateStudent(String id, StudentModel student) async {
    try {
      await _studentsCollection.doc(id).update(student.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar en Firebase: $e');
    }
  }
}
