// Academic, Exam, Fee, Timetable, and Announcement Models

class SubjectAttendance {
  final String subject;
  final String code;
  final int total;
  final int attended;
  final double percentage;
  final bool isShortage;

  SubjectAttendance({
    required this.subject,
    required this.code,
    required this.total,
    required this.attended,
    required this.percentage,
    required this.isShortage,
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      subject: json['subject'] ?? '',
      code: json['code'] ?? '',
      total: json['total'] ?? 0,
      attended: json['attended'] ?? 0,
      percentage: (json['percentage'] != null) ? (json['percentage'] as num).toDouble() : 0.0,
      isShortage: json['isShortage'] ?? false,
    );
  }
}

class ExamResultModel {
  final String id;
  final String examTitle;
  final String examType;
  final String subjectName;
  final String subjectCode;
  final double marksObtained;
  final double maxMarks;
  final String grade;
  final double percentage;
  final String status;
  final String remarks;

  ExamResultModel({
    required this.id,
    required this.examTitle,
    this.examType = 'Final',
    required this.subjectName,
    required this.subjectCode,
    required this.marksObtained,
    required this.maxMarks,
    required this.grade,
    required this.percentage,
    required this.status,
    this.remarks = '',
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    String eTitle = 'Semester Exam';
    String eType = 'Final';
    if (json['examination'] is Map) {
      eTitle = json['examination']['title'] ?? eTitle;
      eType = json['examination']['examType'] ?? eType;
    }

    String sName = 'Subject';
    String sCode = 'CS101';
    if (json['subject'] is Map) {
      sName = json['subject']['name'] ?? sName;
      sCode = json['subject']['code'] ?? sCode;
    }

    return ExamResultModel(
      id: json['_id'] ?? json['id'] ?? '',
      examTitle: eTitle,
      examType: eType,
      subjectName: sName,
      subjectCode: sCode,
      marksObtained: (json['marksObtained'] != null) ? (json['marksObtained'] as num).toDouble() : 0.0,
      maxMarks: (json['maxMarks'] != null) ? (json['maxMarks'] as num).toDouble() : 100.0,
      grade: json['grade'] ?? 'A',
      percentage: (json['percentage'] != null) ? (json['percentage'] as num).toDouble() : 85.0,
      status: json['status'] ?? 'Pass',
      remarks: json['remarks'] ?? '',
    );
  }
}

class FeeModel {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String title;
  final String academicYear;
  final int semester;
  final String feeType;
  final double totalAmount;
  final double paidAmount;
  final String dueDate;
  final String? paidDate;
  final String paymentMethod;
  final String transactionId;
  final String receiptNumber;
  final String status; // 'Paid' | 'Pending' | 'Partial' | 'Overdue'

  FeeModel({
    required this.id,
    required this.studentId,
    this.studentName = '',
    this.rollNumber = '',
    required this.title,
    this.academicYear = '2025-2026',
    this.semester = 1,
    this.feeType = 'Tuition',
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.dueDate,
    this.paidDate,
    this.paymentMethod = 'Online / UPI',
    this.transactionId = '',
    this.receiptNumber = '',
    this.status = 'Pending',
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    String sId = '';
    String sName = '';
    String rNum = '';

    if (json['student'] is Map) {
      sId = json['student']['_id'] ?? '';
      rNum = json['student']['rollNumber'] ?? '';
      if (json['student']['user'] is Map) {
        sName = json['student']['user']['name'] ?? '';
      }
    } else {
      sId = json['student']?.toString() ?? '';
    }

    return FeeModel(
      id: json['_id'] ?? json['id'] ?? '',
      studentId: sId,
      studentName: sName,
      rollNumber: rNum,
      title: json['title'] ?? 'Semester Fee',
      academicYear: json['academicYear'] ?? '2025-2026',
      semester: json['semester'] ?? 1,
      feeType: json['feeType'] ?? 'Tuition',
      totalAmount: (json['totalAmount'] != null) ? (json['totalAmount'] as num).toDouble() : 0.0,
      paidAmount: (json['paidAmount'] != null) ? (json['paidAmount'] as num).toDouble() : 0.0,
      dueDate: json['dueDate']?.toString().split('T')[0] ?? '2025-11-30',
      paidDate: json['paidDate']?.toString().split('T')[0],
      paymentMethod: json['paymentMethod'] ?? 'Online',
      transactionId: json['transactionId'] ?? '',
      receiptNumber: json['receiptNumber'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }
}

class TimetablePeriod {
  final int periodNumber;
  final String startTime;
  final String endTime;
  final String subjectName;
  final String subjectCode;
  final String facultyName;
  final String roomNumber;

  TimetablePeriod({
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    required this.subjectName,
    required this.subjectCode,
    required this.facultyName,
    required this.roomNumber,
  });

  factory TimetablePeriod.fromJson(Map<String, dynamic> json) {
    String subName = 'Subject';
    String subCode = 'CS101';
    if (json['subject'] is Map) {
      subName = json['subject']['name'] ?? subName;
      subCode = json['subject']['code'] ?? subCode;
    }

    String facName = 'Faculty';
    if (json['faculty'] is Map && json['faculty']['user'] is Map) {
      facName = json['faculty']['user']['name'] ?? facName;
    }

    return TimetablePeriod(
      periodNumber: json['periodNumber'] ?? 1,
      startTime: json['startTime'] ?? '09:00 AM',
      endTime: json['endTime'] ?? '10:00 AM',
      subjectName: subName,
      subjectCode: subCode,
      facultyName: facName,
      roomNumber: json['roomNumber'] ?? 'LH-101',
    );
  }
}

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String targetAudience;
  final String priority;
  final String authorName;
  final String date;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.targetAudience = 'all',
    this.priority = 'medium',
    this.authorName = 'Administration',
    required this.date,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      targetAudience: json['targetAudience'] ?? 'all',
      priority: json['priority'] ?? 'medium',
      authorName: json['authorName'] ?? 'Administration',
      date: json['publishDate']?.toString().split('T')[0] ?? json['createdAt']?.toString().split('T')[0] ?? 'Today',
    );
  }
}

class AssignmentModel {
  final String id;
  final String title;
  final String description;
  final String subjectName;
  final String subjectCode;
  final String facultyName;
  final int totalMarks;
  final String dueDate;
  final bool isSubmitted;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectName,
    required this.subjectCode,
    this.facultyName = 'Professor',
    this.totalMarks = 20,
    required this.dueDate,
    this.isSubmitted = false,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    String subName = 'Coursework';
    String subCode = 'CS101';
    if (json['subject'] is Map) {
      subName = json['subject']['name'] ?? subName;
      subCode = json['subject']['code'] ?? subCode;
    }

    String facName = 'Faculty';
    if (json['faculty'] is Map && json['faculty']['user'] is Map) {
      facName = json['faculty']['user']['name'] ?? facName;
    }

    return AssignmentModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subjectName: subName,
      subjectCode: subCode,
      facultyName: facName,
      totalMarks: json['totalMarks'] ?? 20,
      dueDate: json['dueDate']?.toString().split('T')[0] ?? '2025-11-20',
      isSubmitted: json['isSubmitted'] ?? false,
    );
  }
}

