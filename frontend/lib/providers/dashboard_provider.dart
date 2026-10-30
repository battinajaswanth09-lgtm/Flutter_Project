import 'package:flutter/foundation.dart';
import '../models/student_model.dart';
import '../models/academic_models.dart';
import '../services/api_service.dart';
import '../services/mock_data_service.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  int _totalStudents = 420;
  int _totalFaculty = 38;
  int _totalDepartments = 4;
  int _totalCourses = 8;
  double _totalFeeCollected = 184500;
  double _totalFeePending = 32000;
  double _attendanceAverage = 84.5;
  List<StudentModel> _shortageStudents = [];
  List<AnnouncementModel> _announcements = [];

  bool get isLoading => _isLoading;
  int get totalStudents => _totalStudents;
  int get totalFaculty => _totalFaculty;
  int get totalDepartments => _totalDepartments;
  int get totalCourses => _totalCourses;
  double get totalFeeCollected => _totalFeeCollected;
  double get totalFeePending => _totalFeePending;
  double get attendanceAverage => _attendanceAverage;
  List<StudentModel> get shortageStudents => _shortageStudents;
  List<AnnouncementModel> get announcements => _announcements;

  DashboardProvider() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get('/admin/dashboard-stats');
      if (res['success'] == true) {
        final data = res['data'];
        _totalStudents = data['totalStudents'] ?? 420;
        _totalFaculty = data['totalFaculty'] ?? 38;
        _totalDepartments = data['totalDepartments'] ?? 4;
        _totalCourses = data['totalCourses'] ?? 8;
        _totalFeeCollected = (data['totalFeeCollected'] as num?)?.toDouble() ?? 184500;
        _totalFeePending = (data['totalFeePending'] as num?)?.toDouble() ?? 32000;
        _attendanceAverage = (data['attendanceAverage'] as num?)?.toDouble() ?? 84.5;
      }
    } catch (_) {
      // Fallback to rich mock data
      final allStudents = MockDataService.getStudents();
      _shortageStudents = allStudents.where((s) => s.overallAttendance < 75.0).toList();
      _announcements = MockDataService.getAnnouncements();
    } finally {
      if (_shortageStudents.isEmpty) {
        final allStudents = MockDataService.getStudents();
        _shortageStudents = allStudents.where((s) => s.overallAttendance < 75.0).toList();
      }
      if (_announcements.isEmpty) {
        _announcements = MockDataService.getAnnouncements();
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
