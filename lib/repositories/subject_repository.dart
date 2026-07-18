import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/models.dart';

class SubjectRepository {
  final CollectionReference _subjectsCollection = FirebaseFirestore.instance
      .collection('subjects');

  Stream<List<SubjectModel>> getSubjectsStream() {
    return _subjectsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SubjectModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<void> addSubject(SubjectModel subject) async {
    try {
      await _subjectsCollection.add(subject.toFirestore());
    } catch (e) {
      throw Exception('Error al guardar materia en Firebase: $e');
    }
  }

  Future<void> updateSubject(String id, SubjectModel subject) async {
    try {
      await _subjectsCollection.doc(id).update(subject.toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar materia en Firebase: $e');
    }
  }
}
