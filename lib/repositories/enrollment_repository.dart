import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/models.dart';

class EnrollmentRepository {
  final CollectionReference _enrollmentsCollection = FirebaseFirestore.instance
      .collection('enrollments');

  Future<void> registerEnrollmentWithTransaction(
    EnrollmentModel enrollment,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        final QuerySnapshot duplicateCheck = await _enrollmentsCollection
            .where('studentId', isEqualTo: enrollment.studentId)
            .where('subjectId', isEqualTo: enrollment.subjectId)
            .get();

        if (duplicateCheck.docs.isNotEmpty) {
          throw 'El alumno ya se encuentra inscrito en esta materia.';
        }

        final DocumentReference newEnrollmentRef = _enrollmentsCollection.doc();
        transaction.set(newEnrollmentRef, enrollment.toFirestore());
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<List<EnrollmentModel>> getEnrollmentsStream() {
    return _enrollmentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return EnrollmentModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}
