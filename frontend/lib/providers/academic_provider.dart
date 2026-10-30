import 'package:flutter/foundation.dart';
import '../models/academic_models.dart';
import '../models/department_model.dart';
import '../services/mock_data_service.dart';

class AcademicProvider with ChangeNotifier {
  List<DepartmentModel> _departments = [];
  List<SubjectAttendance> _studentAttendance = [];
  List<ExamResultModel> _examResults = [];
  List<FeeModel> _fees = [];
  List<TimetablePeriod> _timetable = [];
  List<AnnouncementModel> _announcements = [];
  List<AssignmentModel> _assignments = [];

  // Attendance marking state for faculty
  Map<String, String> _attendanceSheet = {}; // studentId -> 'Present'|'Absent'|'Late'

  bool _isLoading = false;

  List<DepartmentModel> get departments => _departments;
  List<SubjectAttendance> get studentAttendance => _studentAttendance;
  List<ExamResultModel> get examResults => _examResults;
  List<FeeModel> get fees => _fees;
  List<TimetablePeriod> get timetable => _timetable;
  List<AnnouncementModel> get announcements => _announcements;
  List<AssignmentModel> get assignments => _assignments;
  Map<String, String> get attendanceSheet => _attendanceSheet;
  bool get isLoading => _isLoading;

  AcademicProvider() {
    loadAllAcademicData();
  }

  void loadAllAcademicData() {
    _isLoading = true;
    notifyListeners();

    _departments = MockDataService.getDepartments();
    _studentAttendance = MockDataService.getStudentAttendance();
    _examResults = MockDataService.getStudentResults();
    _fees = MockDataService.getFees();
    _timetable = MockDataService.getTimetable();
    _announcements = MockDataService.getAnnouncements();
    _assignments = MockDataService.getAssignments();

    // Default attendance sheet
    for (var s in MockDataService.getStudents()) {
      _attendanceSheet[s.id] = 'Present';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setStudentAttendanceStatus(String studentId, String status) {
    _attendanceSheet[studentId] = status;
    notifyListeners();
  }

  void addAnnouncement(AnnouncementModel a) {
    _announcements.insert(0, a);
    notifyListeners();
  }

  void addAssignment(AssignmentModel a) {
    _assignments.insert(0, a);
    notifyListeners();
  }

  void recordFeePayment(String feeId, double amount, String method) {
    final index = _fees.indexWhere((f) => f.id == feeId);
    if (index != -1) {
      final old = _fees[index];
      final newPaid = old.paidAmount + amount;
      final newStatus = newPaid >= old.totalAmount ? 'Paid' : 'Partial';

      _fees[index] = FeeModel(
        id: old.id,
        studentId: old.studentId,
        studentName: old.studentName,
        rollNumber: old.rollNumber,
        title: old.title,
        academicYear: old.academicYear,
        semester: old.semester,
        feeType: old.feeType,
        totalAmount: old.totalAmount,
        paidAmount: newPaid,
        dueDate: old.dueDate,
        paidDate: DateTime.now().toString().split(' ')[0],
        paymentMethod: method,
        transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch}',
        receiptNumber: 'REC-2025-${1000 + index}',
        status: newStatus,
      );
      notifyListeners();
    }
  }

  void addExamResult(ExamResultModel res) {
    _examResults.insert(0, res);
    notifyListeners();
  }
}
