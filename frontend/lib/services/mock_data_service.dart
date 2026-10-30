import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/faculty_model.dart';
import '../models/department_model.dart';
import '../models/academic_models.dart';

class MockDataService {
  // Pre-configured Demo Users
  static UserModel get adminUser => UserModel(
        id: 'usr-admin-01',
        name: 'Dr. Arthur Pendelton',
        email: 'admin@college.edu',
        role: 'admin',
        phone: '+1 (555) 019-2834',
        avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=250&q=80',
      );

  static UserModel get facultyUser => UserModel(
        id: 'usr-fac-01',
        name: 'Prof. Robert C. Martin',
        email: 'faculty@college.edu',
        role: 'faculty',
        phone: '+1 (555) 345-9821',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
      );

  static UserModel get studentUser => UserModel(
        id: 'usr-stud-01',
        name: 'Alex Johnson',
        email: 'student@college.edu',
        role: 'student',
        phone: '+1 (555) 432-8765',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      );

  // Departments
  static List<DepartmentModel> getDepartments() {
    return [
      DepartmentModel(
        id: 'dept-01',
        name: 'Computer Science & Engineering',
        code: 'CSE',
        description: 'Artificial intelligence, algorithms, distributed systems & cloud computing.',
        headOfDepartment: 'Dr. Alan Turing',
        establishedYear: 2004,
        studentCount: 165,
        facultyCount: 14,
        contactEmail: 'cse@college.edu',
        phone: '+1 555-101-2001',
      ),
      DepartmentModel(
        id: 'dept-02',
        name: 'Electronics & Communication',
        code: 'ECE',
        description: 'Microprocessors, VLSI design, wireless signal transmission & IoT.',
        headOfDepartment: 'Dr. Claude Shannon',
        establishedYear: 2006,
        studentCount: 120,
        facultyCount: 10,
        contactEmail: 'ece@college.edu',
        phone: '+1 555-101-2002',
      ),
      DepartmentModel(
        id: 'dept-03',
        name: 'Mechanical Engineering',
        code: 'MECH',
        description: 'Robotics, fluid mechanics, CAD design and automotive propulsion.',
        headOfDepartment: 'Dr. Nikola Tesla',
        establishedYear: 2002,
        studentCount: 95,
        facultyCount: 8,
        contactEmail: 'mech@college.edu',
        phone: '+1 555-101-2003',
      ),
      DepartmentModel(
        id: 'dept-04',
        name: 'Civil Engineering',
        code: 'CIVIL',
        description: 'Structural engineering, geodesy, and smart urban infrastructure.',
        headOfDepartment: 'Dr. Emily Roebling',
        establishedYear: 2001,
        studentCount: 78,
        facultyCount: 7,
        contactEmail: 'civil@college.edu',
        phone: '+1 555-101-2004',
      ),
    ];
  }

  // Students
  static List<StudentModel> getStudents() {
    return [
      StudentModel(
        id: 'std-01',
        userId: 'usr-stud-01',
        name: 'Alex Johnson',
        email: 'student@college.edu',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 432-8765',
        rollNumber: 'CSE-2023-042',
        registrationNumber: 'REG-2023-90812',
        departmentId: 'dept-01',
        departmentName: 'Computer Science & Engineering',
        departmentCode: 'CSE',
        courseId: 'crs-01',
        courseTitle: 'B.Tech in Computer Science',
        semester: 5,
        section: 'A',
        batchYear: '2023-2027',
        gender: 'Female',
        bloodGroup: 'B+',
        guardianName: 'Mark Johnson',
        guardianPhone: '+1 (555) 432-8700',
        overallAttendance: 88.5,
        cgpa: 8.75,
        status: 'Active',
      ),
      StudentModel(
        id: 'std-02',
        userId: 'usr-stud-02',
        name: 'Ethan Hunt',
        email: 'ethan.hunt@college.edu',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 234-9012',
        rollNumber: 'CSE-2023-018',
        registrationNumber: 'REG-2023-90813',
        departmentId: 'dept-01',
        departmentName: 'Computer Science & Engineering',
        departmentCode: 'CSE',
        courseId: 'crs-01',
        courseTitle: 'B.Tech in Computer Science',
        semester: 5,
        section: 'A',
        batchYear: '2023-2027',
        gender: 'Male',
        bloodGroup: 'O+',
        guardianName: 'William Hunt',
        guardianPhone: '+1 (555) 234-9000',
        overallAttendance: 71.0, // Shortage alert!
        cgpa: 7.9,
        status: 'Active',
      ),
      StudentModel(
        id: 'std-03',
        userId: 'usr-stud-03',
        name: 'Sophia Martinez',
        email: 'sophia.m@college.edu',
        avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 998-1123',
        rollNumber: 'CSE-2023-055',
        registrationNumber: 'REG-2023-90814',
        departmentId: 'dept-01',
        departmentName: 'Computer Science & Engineering',
        departmentCode: 'CSE',
        courseId: 'crs-01',
        courseTitle: 'B.Tech in Computer Science',
        semester: 5,
        section: 'A',
        batchYear: '2023-2027',
        gender: 'Female',
        bloodGroup: 'A+',
        guardianName: 'Carlos Martinez',
        guardianPhone: '+1 (555) 998-1100',
        overallAttendance: 94.0,
        cgpa: 9.2,
        status: 'Active',
      ),
      StudentModel(
        id: 'std-04',
        userId: 'usr-stud-04',
        name: 'Liam Chen',
        email: 'liam.chen@college.edu',
        avatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 674-8891',
        rollNumber: 'ECE-2023-023',
        registrationNumber: 'REG-2023-90815',
        departmentId: 'dept-02',
        departmentName: 'Electronics & Communication',
        departmentCode: 'ECE',
        courseId: 'crs-02',
        courseTitle: 'B.Tech in Electronics',
        semester: 5,
        section: 'B',
        batchYear: '2023-2027',
        gender: 'Male',
        bloodGroup: 'AB+',
        guardianName: 'David Chen',
        guardianPhone: '+1 (555) 674-8800',
        overallAttendance: 68.5, // Shortage alert!
        cgpa: 7.4,
        status: 'Active',
      ),
    ];
  }

  // Faculty
  static List<FacultyModel> getFaculty() {
    return [
      FacultyModel(
        id: 'fac-01',
        userId: 'usr-fac-01',
        name: 'Prof. Robert C. Martin',
        email: 'faculty@college.edu',
        avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 345-9821',
        employeeId: 'FAC-CSE-001',
        departmentId: 'dept-01',
        departmentName: 'Computer Science & Engineering',
        departmentCode: 'CSE',
        designation: 'Professor',
        qualification: 'Ph.D. in Computer Science',
        specialization: 'Software Architecture & Cloud Systems',
        experienceYears: 12,
        assignedSubjects: ['Data Structures & Algorithms', 'Computer Networks'],
      ),
      FacultyModel(
        id: 'fac-02',
        userId: 'usr-fac-02',
        name: 'Dr. Grace Hopper',
        email: 'grace.hopper@college.edu',
        avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 789-1122',
        employeeId: 'FAC-CSE-002',
        departmentId: 'dept-01',
        departmentName: 'Computer Science & Engineering',
        departmentCode: 'CSE',
        designation: 'Associate Professor',
        qualification: 'Ph.D. in Compiler Design',
        specialization: 'Database Systems & Operating Systems',
        experienceYears: 9,
        assignedSubjects: ['Database Management Systems', 'Operating Systems'],
      ),
      FacultyModel(
        id: 'fac-03',
        userId: 'usr-fac-03',
        name: 'Dr. James Maxwell',
        email: 'maxwell@college.edu',
        avatar: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=250&q=80',
        phone: '+1 (555) 887-3344',
        employeeId: 'FAC-ECE-001',
        departmentId: 'dept-02',
        departmentName: 'Electronics & Communication',
        departmentCode: 'ECE',
        designation: 'Professor',
        qualification: 'Ph.D. in Electromagnetics',
        specialization: 'Signal Processing & Antennas',
        experienceYears: 15,
        assignedSubjects: ['Digital Signal Processing', 'Electromagnetic Waves'],
      ),
    ];
  }

  // Announcements
  static List<AnnouncementModel> getAnnouncements() {
    return [
      AnnouncementModel(
        id: 'ann-01',
        title: 'Semester 5 Mid-Term Examinations Schedule Released',
        content: 'The Semester 5 Mid-term Examinations will commence from the 15th of next month. Students must clear any pending fees to download their hall tickets.',
        targetAudience: 'all',
        priority: 'high',
        authorName: 'Office of the Controller of Examinations',
        date: '2025-10-28',
      ),
      AnnouncementModel(
        id: 'ann-02',
        title: 'Annual Hackathon "TechNovation 2026" Registrations Open',
        content: '36-hour hackathon with cash prizes totaling \$10,000 sponsored by tech partners. Open to all engineering students. Form teams of 3 to 4.',
        targetAudience: 'student',
        priority: 'medium',
        authorName: 'Student Affairs Council',
        date: '2025-10-25',
      ),
      AnnouncementModel(
        id: 'ann-03',
        title: 'Faculty Pedagogy Workshop on Generative AI',
        content: 'Workshop on incorporating modern AI tools and automated grading into university curriculum. Conference Hall B at 10:00 AM this Friday.',
        targetAudience: 'faculty',
        priority: 'high',
        authorName: 'Dean of Academic Affairs',
        date: '2025-10-22',
      ),
    ];
  }

  // Attendance summary for Alex Johnson
  static List<SubjectAttendance> getStudentAttendance() {
    return [
      SubjectAttendance(
        subject: 'Data Structures and Algorithms',
        code: 'CS301',
        total: 36,
        attended: 33,
        percentage: 91.6,
        isShortage: false,
      ),
      SubjectAttendance(
        subject: 'Database Management Systems',
        code: 'CS302',
        total: 34,
        attended: 30,
        percentage: 88.2,
        isShortage: false,
      ),
      SubjectAttendance(
        subject: 'Computer Networks',
        code: 'CS303',
        total: 32,
        attended: 28,
        percentage: 87.5,
        isShortage: false,
      ),
      SubjectAttendance(
        subject: 'Operating Systems',
        code: 'CS304',
        total: 35,
        attended: 30,
        percentage: 85.7,
        isShortage: false,
      ),
    ];
  }

  // Exam Results for Alex Johnson
  static List<ExamResultModel> getStudentResults() {
    return [
      ExamResultModel(
        id: 'res-01',
        examTitle: 'Semester 5 Mid-Term Examinations',
        examType: 'Midterm',
        subjectName: 'Data Structures & Algorithms',
        subjectCode: 'CS301',
        marksObtained: 94,
        maxMarks: 100,
        grade: 'A+',
        percentage: 94,
        status: 'Pass',
        remarks: 'Outstanding algorithm design & analysis',
      ),
      ExamResultModel(
        id: 'res-02',
        examTitle: 'Semester 5 Mid-Term Examinations',
        examType: 'Midterm',
        subjectName: 'Database Management Systems',
        subjectCode: 'CS302',
        marksObtained: 88,
        maxMarks: 100,
        grade: 'A',
        percentage: 88,
        status: 'Pass',
        remarks: 'Strong relational modeling and indexing skills',
      ),
      ExamResultModel(
        id: 'res-03',
        examTitle: 'Semester 5 Mid-Term Examinations',
        examType: 'Midterm',
        subjectName: 'Computer Networks',
        subjectCode: 'CS303',
        marksObtained: 91,
        maxMarks: 100,
        grade: 'A+',
        percentage: 91,
        status: 'Pass',
        remarks: 'Excellent topology design and packet analysis',
      ),
      ExamResultModel(
        id: 'res-04',
        examTitle: 'Semester 5 Mid-Term Examinations',
        examType: 'Midterm',
        subjectName: 'Operating Systems',
        subjectCode: 'CS304',
        marksObtained: 85,
        maxMarks: 100,
        grade: 'A',
        percentage: 85,
        status: 'Pass',
        remarks: 'Good understanding of deadlock resolution',
      ),
    ];
  }

  // Fees
  static List<FeeModel> getFees() {
    return [
      FeeModel(
        id: 'fee-01',
        studentId: 'std-01',
        studentName: 'Alex Johnson',
        rollNumber: 'CSE-2023-042',
        title: 'Semester 5 Tuition & Campus Facility Fee',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Tuition',
        totalAmount: 45000,
        paidAmount: 45000,
        dueDate: '2025-09-01',
        paidDate: '2025-08-25',
        paymentMethod: 'Online / UPI',
        transactionId: 'UPI-TXN-902847192',
        receiptNumber: 'REC-2025-8819',
        status: 'Paid',
      ),
      FeeModel(
        id: 'fee-02',
        studentId: 'std-01',
        studentName: 'Alex Johnson',
        rollNumber: 'CSE-2023-042',
        title: 'Annual Library & Digital Resource Subscription',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Library',
        totalAmount: 3500,
        paidAmount: 3500,
        dueDate: '2025-09-15',
        paidDate: '2025-09-10',
        paymentMethod: 'Credit/Debit Card',
        transactionId: 'CARD-TXN-382910',
        receiptNumber: 'REC-2025-9014',
        status: 'Paid',
      ),
      FeeModel(
        id: 'fee-03',
        studentId: 'std-02',
        studentName: 'Ethan Hunt',
        rollNumber: 'CSE-2023-018',
        title: 'Semester 5 Tuition Fee',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Tuition',
        totalAmount: 45000,
        paidAmount: 15000,
        dueDate: '2025-11-15',
        paymentMethod: 'Net Banking',
        transactionId: 'BNK-77129',
        receiptNumber: 'REC-2025-9122',
        status: 'Partial',
      ),
      FeeModel(
        id: 'fee-04',
        studentId: 'std-04',
        studentName: 'Liam Chen',
        rollNumber: 'ECE-2023-023',
        title: 'Semester 5 Laboratory & Equipment Fee',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Laboratory',
        totalAmount: 8500,
        paidAmount: 0,
        dueDate: '2025-10-15',
        status: 'Overdue',
      ),
    ];
  }

  // Timetable
  static List<TimetablePeriod> getTimetable() {
    return [
      TimetablePeriod(
        periodNumber: 1,
        startTime: '09:00 AM',
        endTime: '10:00 AM',
        subjectName: 'Data Structures & Algorithms',
        subjectCode: 'CS301',
        facultyName: 'Prof. Robert C. Martin',
        roomNumber: 'LH-301',
      ),
      TimetablePeriod(
        periodNumber: 2,
        startTime: '10:00 AM',
        endTime: '11:00 AM',
        subjectName: 'Database Management Systems',
        subjectCode: 'CS302',
        facultyName: 'Dr. Grace Hopper',
        roomNumber: 'LH-301',
      ),
      TimetablePeriod(
        periodNumber: 3,
        startTime: '11:15 AM',
        endTime: '12:15 PM',
        subjectName: 'Computer Networks',
        subjectCode: 'CS303',
        facultyName: 'Prof. Robert C. Martin',
        roomNumber: 'LH-204',
      ),
      TimetablePeriod(
        periodNumber: 4,
        startTime: '01:30 PM',
        endTime: '03:30 PM',
        subjectName: 'Advanced Computing Lab',
        subjectCode: 'CS305L',
        facultyName: 'Prof. Robert C. Martin',
        roomNumber: 'Software Lab 2',
      ),
    ];
  }

  // Assignments
  static List<AssignmentModel> getAssignments() {
    return [
      AssignmentModel(
        id: 'asg-01',
        title: 'Binary Search Tree & AVL Tree Implementation',
        description: 'Implement AVL rotation algorithms and self-balancing checks. Write test cases with benchmarks.',
        subjectName: 'Data Structures and Algorithms',
        subjectCode: 'CS301',
        facultyName: 'Prof. Robert C. Martin',
        totalMarks: 25,
        dueDate: '2025-11-12',
        isSubmitted: true,
      ),
      AssignmentModel(
        id: 'asg-02',
        title: 'Query Optimization & B-Tree Index Analysis',
        description: 'Execute EXPLAIN queries on 500,000 synthetic records. Document performance differences with clustered vs unclustered indices.',
        subjectName: 'Database Management Systems',
        subjectCode: 'CS302',
        facultyName: 'Dr. Grace Hopper',
        totalMarks: 20,
        dueDate: '2025-11-20',
        isSubmitted: false,
      ),
      AssignmentModel(
        id: 'asg-03',
        title: 'TCP vs UDP Throughput Simulation',
        description: 'Simulate packet congestion and loss over simulated network using NS-3 or Wireshark traces.',
        subjectName: 'Computer Networks',
        subjectCode: 'CS303',
        facultyName: 'Prof. Robert C. Martin',
        totalMarks: 20,
        dueDate: '2025-11-28',
        isSubmitted: false,
      ),
    ];
  }
}

