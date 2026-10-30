class FacultyModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String employeeId;
  final String departmentId;
  final String departmentName;
  final String departmentCode;
  final String designation;
  final String qualification;
  final String specialization;
  final int experienceYears;
  final List<String> assignedSubjects;
  final String salaryStatus;

  FacultyModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.avatar,
    this.phone = '',
    required this.employeeId,
    required this.departmentId,
    this.departmentName = 'Computer Science',
    this.departmentCode = 'CSE',
    this.designation = 'Assistant Professor',
    this.qualification = 'M.Tech / Ph.D',
    this.specialization = 'Software Engineering',
    this.experienceYears = 5,
    this.assignedSubjects = const [],
    this.salaryStatus = 'Paid',
  });

  factory FacultyModel.fromJson(Map<String, dynamic> json) {
    String uId = '';
    String uName = '';
    String uEmail = '';
    String uAvatar = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80';
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

    List<String> subjects = [];
    if (json['assignedSubjects'] is List) {
      for (var s in json['assignedSubjects']) {
        if (s is Map) {
          subjects.add(s['name'] ?? '');
        } else {
          subjects.add(s.toString());
        }
      }
    }

    return FacultyModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: uId,
      name: uName.isNotEmpty ? uName : (json['name'] ?? 'Faculty Member'),
      email: uEmail.isNotEmpty ? uEmail : (json['email'] ?? ''),
      avatar: uAvatar,
      phone: uPhone.isNotEmpty ? uPhone : (json['phone'] ?? ''),
      employeeId: json['employeeId'] ?? 'FAC-001',
      departmentId: deptId,
      departmentName: deptName,
      departmentCode: deptCode,
      designation: json['designation'] ?? 'Assistant Professor',
      qualification: json['qualification'] ?? 'M.Tech / Ph.D',
      specialization: json['specialization'] ?? 'Computer Science',
      experienceYears: json['experienceYears'] ?? 5,
      assignedSubjects: subjects,
      salaryStatus: json['salaryStatus'] ?? 'Paid',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'employeeId': employeeId,
      'department': departmentId,
      'designation': designation,
      'qualification': qualification,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'phone': phone,
    };
  }
}

