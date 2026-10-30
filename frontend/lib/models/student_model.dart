class StudentModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String rollNumber;
  final String registrationNumber;
  final String departmentId;
  final String departmentName;
  final String departmentCode;
  final String courseId;
  final String courseTitle;
  final int semester;
  final String section;
  final String batchYear;
  final String gender;
  final String bloodGroup;
  final String address;
  final String guardianName;
  final String guardianPhone;
  final double overallAttendance;
  final double cgpa;
  final String status;

  StudentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.avatar,
    this.phone = '',
    required this.rollNumber,
    this.registrationNumber = '',
    required this.departmentId,
    this.departmentName = 'Computer Science',
    this.departmentCode = 'CSE',
    required this.courseId,
    this.courseTitle = 'B.Tech CSE',
    this.semester = 1,
    this.section = 'A',
    this.batchYear = '2023-2027',
    this.gender = 'Male',
    this.bloodGroup = 'O+',
    this.address = '',
    this.guardianName = '',
    this.guardianPhone = '',
    this.overallAttendance = 85.0,
    this.cgpa = 8.0,
    this.status = 'Active',
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    String uId = '';
    String uName = '';
    String uEmail = '';
    String uAvatar = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80';
    String uPhone = '';

    if (json['user'] is Map) {
      uId = json['user']['_id'] ?? json['user']['id'] ?? '';
      uName = json['user']['name'] ?? '';
      uEmail = json['user']['email'] ?? '';
      uAvatar = json['user']['avatar'] ?? uAvatar;
      uPhone = json['user']['phone'] ?? '';
    } else {
      uId = json['user']?.toString() ?? '';
    }

    String deptId = '';
    String deptName = 'Computer Science';
    String deptCode = 'CSE';
    if (json['department'] is Map) {
      deptId = json['department']['_id'] ?? '';
      deptName = json['department']['name'] ?? deptName;
      deptCode = json['department']['code'] ?? deptCode;
    } else {
      deptId = json['department']?.toString() ?? '';
    }

    String cId = '';
    String cTitle = 'B.Tech CSE';
    if (json['course'] is Map) {
      cId = json['course']['_id'] ?? '';
      cTitle = json['course']['title'] ?? cTitle;
    } else {
      cId = json['course']?.toString() ?? '';
    }

    return StudentModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: uId,
      name: uName.isNotEmpty ? uName : (json['name'] ?? 'Student'),
      email: uEmail.isNotEmpty ? uEmail : (json['email'] ?? ''),
      avatar: uAvatar,
      phone: uPhone.isNotEmpty ? uPhone : (json['phone'] ?? ''),
      rollNumber: json['rollNumber'] ?? 'ROLL-001',
      registrationNumber: json['registrationNumber'] ?? '',
      departmentId: deptId,
      departmentName: deptName,
      departmentCode: deptCode,
      courseId: cId,
      courseTitle: cTitle,
      semester: json['semester'] ?? 1,
      section: json['section'] ?? 'A',
      batchYear: json['batchYear'] ?? '2023-2027',
      gender: json['gender'] ?? 'Male',
      bloodGroup: json['bloodGroup'] ?? 'O+',
      address: json['address'] ?? '',
      guardianName: json['guardianName'] ?? '',
      guardianPhone: json['guardianPhone'] ?? '',
      overallAttendance: (json['overallAttendance'] != null) ? (json['overallAttendance'] as num).toDouble() : 85.0,
      cgpa: (json['cgpa'] != null) ? (json['cgpa'] as num).toDouble() : 8.0,
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'registrationNumber': registrationNumber,
      'department': departmentId,
      'course': courseId,
      'semester': semester,
      'section': section,
      'batchYear': batchYear,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'phone': phone,
      'overallAttendance': overallAttendance,
      'cgpa': cgpa,
      'status': status,
    };
  }
}
