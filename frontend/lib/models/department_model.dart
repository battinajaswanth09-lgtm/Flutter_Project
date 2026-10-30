class DepartmentModel {
  final String id;
  final String name;
  final String code;
  final String description;
  final String headOfDepartment;
  final int establishedYear;
  final String contactEmail;
  final String phone;
  final int studentCount;
  final int facultyCount;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
    this.description = '',
    this.headOfDepartment = 'Dr. Alan Turing',
    this.establishedYear = 2004,
    this.contactEmail = '',
    this.phone = '',
    this.studentCount = 0,
    this.facultyCount = 0,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      headOfDepartment: json['headOfDepartment'] ?? 'Dr. Alan Turing',
      establishedYear: json['establishedYear'] ?? 2004,
      contactEmail: json['contactEmail'] ?? '',
      phone: json['phone'] ?? '',
      studentCount: json['students'] ?? json['studentCount'] ?? 0,
      facultyCount: json['faculty'] ?? json['facultyCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'description': description,
      'headOfDepartment': headOfDepartment,
      'establishedYear': establishedYear,
      'contactEmail': contactEmail,
      'phone': phone,
    };
  }
}

class CourseModel {
  final String id;
  final String title;
  final String code;
  final String departmentId;
  final String departmentName;
  final int durationYears;
  final int totalSemesters;
  final int credits;

  CourseModel({
    required this.id,
    required this.title,
    required this.code,
    required this.departmentId,
    this.departmentName = '',
    this.durationYears = 4,
    this.totalSemesters = 8,
    this.credits = 160,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    String deptId = '';
    String deptName = '';
    if (json['department'] is Map) {
      deptId = json['department']['_id'] ?? '';
      deptName = json['department']['name'] ?? '';
    } else {
      deptId = json['department']?.toString() ?? '';
    }

    return CourseModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      departmentId: deptId,
      departmentName: deptName,
      durationYears: json['durationYears'] ?? 4,
      totalSemesters: json['totalSemesters'] ?? 8,
      credits: json['credits'] ?? 160,
    );
  }
}

class SubjectModel {
  final String id;
  final String name;
  final String code;
  final int semester;
  final int credits;
  final String facultyName;

  SubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.semester,
    this.credits = 4,
    this.facultyName = '',
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    String facName = '';
    if (json['faculty'] is Map && json['faculty']['user'] is Map) {
      facName = json['faculty']['user']['name'] ?? '';
    }

    return SubjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      semester: json['semester'] ?? 1,
      credits: json['credits'] ?? 4,
      facultyName: facName,
    );
  }
}

