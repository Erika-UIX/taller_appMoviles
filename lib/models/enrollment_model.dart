class EnrollmentModel {
  final String? id;
  final String studentId;
  final String studentName;
  final String subjectId;
  final String subjectName;
  final String date;

  EnrollmentModel({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.subjectId,
    required this.subjectName,
    required this.date,
  });

  Map<String, dynamic> toFirestore() {
    return {
      //'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'date': date,
    };
  }

  factory EnrollmentModel.fromFirestore(String id, Map<String, dynamic> data) {
    return EnrollmentModel(
      id: id,
      studentId: data['studentId'],
      studentName: data['studentName'],
      subjectId: data['subjectId'],
      subjectName: data['subjectName'],
      date: data['date'],
    );
  }
}
