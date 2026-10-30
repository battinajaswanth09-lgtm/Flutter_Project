import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedDepartment;
  int? _selectedSemester;

  List<StudentModel> get students {
    return _students.where((s) {
      final matchesSearch = _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDepartment == null ||
          _selectedDepartment!.isEmpty ||
          s.departmentCode == _selectedDepartment;
      final matchesSem = _selectedSemester == null || s.semester == _selectedSemester;
      return matchesSearch && matchesDept && matchesSem;
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedDepartment => _selectedDepartment;
  int? get selectedSemester => _selectedSemester;

  StudentProvider() {
    loadStudents();
  }

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get('/students');
      if (res['success'] == true && res['data'] is List) {
        _students = (res['data'] as List)
            .map((item) => StudentModel.fromJson(item))
            .toList();
      } else {
        _students = MockDataService.getStudents();
      }
    } catch (_) {
      _students = MockDataService.getStudents();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setDepartmentFilter(String? dept) {
    _selectedDepartment = dept;
    notifyListeners();
  }

  void setSemesterFilter(int? sem) {
    _selectedSemester = sem;
    notifyListeners();
  }

  Future<void> addStudent(StudentModel newStudent) async {
    _students.insert(0, newStudent);
    notifyListeners();
    try {
      await ApiService.post('/students', newStudent.toJson());
    } catch (e) {
      debugPrint('Added locally (offline demo): $e');
    }
  }

  Future<void> updateStudent(StudentModel updatedStudent) async {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
      try {
        await ApiService.put('/students/${updatedStudent.id}', updatedStudent.toJson());
      } catch (e) {
        debugPrint('Updated locally (offline demo): $e');
      }
    }
  }

  Future<void> deleteStudent(String studentId) async {
    _students.removeWhere((s) => s.id == studentId);
    notifyListeners();
    try {
      await ApiService.delete('/students/$studentId');
    } catch (e) {
      debugPrint('Deleted locally (offline demo): $e');
    }
  }
}

