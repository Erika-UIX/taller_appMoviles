class SubjectModel {
  final String? id;
  final String code;
  final String name;
  final int credits;
  final String department;

  SubjectModel({
    this.id,
    required this.code,
    required this.name,
    required this.credits,
    required this.department,
  });

  factory SubjectModel.fromFirestore(String id, Map<String, dynamic> data) {
    return SubjectModel(
      id: id,
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      credits: (data['credits'] ?? 3) is int
          ? (data['credits'] ?? 3)
          : (data['credits'] as num).toInt(),
      department: data['department'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'code': code,
    'name': name,
    'credits': credits,
    'department': department,
  };
}
