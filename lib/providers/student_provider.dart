import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/models/models.dart';
import 'package:myapp/repositories/repositories.dart';

class StudentProvider extends ChangeNotifier {
  final StudentRepository _studentRepository = StudentRepository();

  StreamSubscription<List<StudentModel>>? _studentsSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchLoading = true;
  bool get isFetchLoading => _isFetchLoading;

  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToStudents() {
    if (_studentsSubscription != null) return;

    _isFetchLoading = true;
    _errorMessage = null;

    _studentsSubscription = _studentRepository.getStudentsStream().listen(
      (studentList) {
        _students = studentList;
        _errorMessage = null;
        _isFetchLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error al obtener los alumnos: $error';
        _isFetchLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> registerStudent({
    required String name,
    required String enrollment,
    required String carreer,
    required bool isActive,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newStudent = StudentModel(
        name: name,
        enrollment: enrollment,
        carreer: carreer,
        isActive: isActive,
      );

      await _studentRepository.addStudent(newStudent);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingStudent({
    required String id,
    required String name,
    required String enrollment,
    required String carreer,
    required bool isActive,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedStudent = StudentModel(
        id: id,
        name: name,
        enrollment: enrollment,
        carreer: carreer,
        isActive: isActive,
      );

      await _studentRepository.updateStudent(id, updatedStudent);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _studentsSubscription?.cancel();
    super.dispose();
  }
}
