import 'package:flutter/foundation.dart';
import '../models/faculty_model.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class FacultyProvider with ChangeNotifier {
  List<FacultyModel> _facultyList = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedDepartment;

  List<FacultyModel> get facultyList {
    return _facultyList.where((f) {
      final matchesSearch = _searchQuery.isEmpty ||
          f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.employeeId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.designation.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDept = _selectedDepartment == null ||
          _selectedDepartment!.isEmpty ||
          f.departmentCode == _selectedDepartment;
      return matchesSearch && matchesDept;
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedDepartment => _selectedDepartment;

  FacultyProvider() {
    loadFaculty();
  }

  Future<void> loadFaculty() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get('/faculty');
      if (res['success'] == true && res['data'] is List) {
        _facultyList = (res['data'] as List)
            .map((item) => FacultyModel.fromJson(item))
            .toList();
      } else {
        _facultyList = MockDataService.getFaculty();
      }
    } catch (_) {
      _facultyList = MockDataService.getFaculty();
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

  Future<void> addFaculty(FacultyModel newFaculty) async {
    _facultyList.insert(0, newFaculty);
    notifyListeners();
    try {
      await ApiService.post('/faculty', newFaculty.toJson());
    } catch (_) {}
  }

  Future<void> deleteFaculty(String id) async {
    _facultyList.removeWhere((f) => f.id == id);
    notifyListeners();
    try {
      await ApiService.delete('/faculty/$id');
    } catch (_) {}
  }
}

