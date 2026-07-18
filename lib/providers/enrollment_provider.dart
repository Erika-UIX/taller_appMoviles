import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/models/models.dart';
import 'package:myapp/repositories/repositories.dart';

class EnrollmentProvider extends ChangeNotifier {
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();
  StreamSubscription<List<EnrollmentModel>>? _enrollmentSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetching = true;
  bool get isFetching => _isFetching;

  List<EnrollmentModel> _enrollments = [];
  List<EnrollmentModel> get enrollments => _enrollments;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToEnrollments() {
    if (_enrollmentSubscription != null) return;

    _isFetching = true;
    _errorMessage = null;

    _enrollmentSubscription = _enrollmentRepository
        .getEnrollmentsStream()
        .listen(
          (enrollments) {
            _enrollments = enrollments;
            _isFetching = false;
            _errorMessage = null;
            notifyListeners();
          },
          onError: (error) {
            _errorMessage = 'Error al cargar asignaciones: $error';
            _isFetching = false;
            notifyListeners();
          },
        );
  }

  Future<String?> createEnrollment({
    required String studentId,
    required String studentName,
    required String subjectId,
    required String subjectName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final enrollment = EnrollmentModel(
        studentId: studentId,
        studentName: studentName,
        subjectId: subjectId,
        subjectName: subjectName,
        date: DateTime.now().toIso8601String(),
      );

      await _enrollmentRepository.registerEnrollmentWithTransaction(enrollment);
      _isLoading = false;
      notifyListeners();
      return null; // No error
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return error.toString();
    }
  }

  @override
  void dispose() {
    _enrollmentSubscription?.cancel();
    super.dispose();
  }
}
