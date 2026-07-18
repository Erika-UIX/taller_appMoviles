import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/models/models.dart';
import 'package:myapp/repositories/repositories.dart';

class SubjectProvider extends ChangeNotifier {
  final SubjectRepository _subjectRepository = SubjectRepository();
  StreamSubscription<List<SubjectModel>>? _subjectSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFetchLoading = true;
  bool get isFetchLoading => _isFetchLoading;

  List<SubjectModel> _subjects = [];
  List<SubjectModel> get subjects => _subjects;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void listenToSubjects() {
    if (_subjectSubscription != null) return;

    _isFetchLoading = true;
    _errorMessage = null;

    _subjectSubscription = _subjectRepository.getSubjectsStream().listen(
      (subjects) {
        _subjects = subjects;
        _isFetchLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error al obtener las materias: $error';
        _isFetchLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> registerSubject({
    required String code,
    required String name,
    required int credits,
    required String department,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newSubject = SubjectModel(
        code: code,
        name: name,
        credits: credits,
        department: department,
      );

      await _subjectRepository.addSubject(newSubject);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExistingSubject({
    required String id,
    required String code,
    required String name,
    required int credits,
    required String department,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedSubject = SubjectModel(
        code: code,
        name: name,
        credits: credits,
        department: department,
      );

      await _subjectRepository.updateSubject(id, updatedSubject);

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
    _subjectSubscription?.cancel();
    super.dispose();
  }
}
