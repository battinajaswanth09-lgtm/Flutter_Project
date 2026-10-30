const express = require('express');
const jwt = require('jsonwebtoken');
const fakeDb = require('../config/fakeDb');
const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'super_secret_jwt_token_college_mgmt_2025_secure_key';

// Helper to generate real JWT token for in-memory session
const generateToken = (user) => {
  return jwt.sign({ id: user.id || user._id, role: user.role }, JWT_SECRET, {
    expiresIn: '7d',
  });
};

// -------------------------------------------------------------
// Authentication Routes
// -------------------------------------------------------------
router.post('/auth/login', (req, res) => {
  const { email, password } = req.body;

  let user = fakeDb.users.find((u) => u.email.toLowerCase() === (email || '').toLowerCase());

  if (!user) {
    // If not found by exact email, allow easy demo fallback based on role keyword
    if (email && email.includes('admin')) {
      user = fakeDb.users.find((u) => u.role === 'admin');
    } else if (email && email.includes('faculty')) {
      user = fakeDb.users.find((u) => u.role === 'faculty');
    } else {
      user = fakeDb.users.find((u) => u.role === 'student');
    }
  }

  const token = generateToken(user);
  res.status(200).json({
    success: true,
    token,
    user: {
      id: user.id || user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      avatar: user.avatar,
      phone: user.phone,
    },
    profile: user.role === 'student' ? fakeDb.students[0] : (user.role === 'faculty' ? fakeDb.faculty[0] : null),
  });
});

router.post('/auth/register', (req, res) => {
  const { name, email, password, role, phone } = req.body;
  const newUser = {
    id: `usr-${Date.now()}`,
    _id: `usr-${Date.now()}`,
    name,
    email,
    password: password || 'Password123!',
    role: role || 'student',
    phone: phone || '',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
    isActive: true,
  };
  fakeDb.users.push(newUser);
  const token = generateToken(newUser);
  res.status(201).json({ success: true, token, user: newUser });
});

router.get('/auth/me', (req, res) => {
  res.status(200).json({ success: true, user: fakeDb.users[0] });
});

router.put('/auth/updateprofile', (req, res) => {
  res.status(200).json({ success: true, message: 'Profile updated in fake DB' });
});

// -------------------------------------------------------------
// Admin Analytics & Dashboard
// -------------------------------------------------------------
router.get('/admin/dashboard-stats', (req, res) => {
  let totalFeeCollected = 0;
  let totalFeePending = 0;
  fakeDb.fees.forEach((f) => {
    totalFeeCollected += f.paidAmount || 0;
    totalFeePending += Math.max(0, f.totalAmount - (f.paidAmount || 0));
  });

  const shortageStudents = fakeDb.students.filter((s) => s.overallAttendance < 75.0);

  res.status(200).json({
    success: true,
    data: {
      totalStudents: fakeDb.students.length + 417, // Realistic campus scale
      totalFaculty: fakeDb.faculty.length + 36,
      totalDepartments: fakeDb.departments.length,
      totalCourses: fakeDb.courses.length,
      totalFeeCollected: totalFeeCollected + 140000,
      totalFeePending: totalFeePending + 20000,
      attendanceAverage: 84.5,
      shortageCount: shortageStudents.length,
      shortageStudents,
      recentAnnouncements: fakeDb.announcements,
      departmentStats: fakeDb.departments.map((d) => ({
        id: d.id,
        name: d.name,
        code: d.code,
        students: d.studentCount,
        faculty: d.facultyCount,
      })),
    },
  });
});

router.get('/admin/reports', (req, res) => {
  res.status(200).json({
    success: true,
    data: {
      studentsByYear: [
        { year: '1st Year', count: 120, avgAttendance: 88, passRate: 92 },
        { year: '2nd Year', count: 110, avgAttendance: 84, passRate: 89 },
        { year: '3rd Year', count: 98, avgAttendance: 82, passRate: 87 },
        { year: '4th Year', count: 95, avgAttendance: 85, passRate: 94 },
      ],
      feeCollectionMonthly: [
        { month: 'Jan', collected: 45000, pending: 8000 },
        { month: 'Feb', collected: 52000, pending: 6500 },
        { month: 'Mar', collected: 61000, pending: 4200 },
        { month: 'Apr', collected: 48000, pending: 5900 },
        { month: 'May', collected: 58000, pending: 3100 },
        { month: 'Jun', collected: 72000, pending: 2000 },
      ],
    },
  });
});

// -------------------------------------------------------------
// Students CRUD
// -------------------------------------------------------------
router.get('/students', (req, res) => {
  const { department, search } = req.query;
  let list = [...fakeDb.students];

  if (department) {
    list = list.filter((s) => s.department && s.department.code === department);
  }
  if (search) {
    const term = search.toLowerCase();
    list = list.filter(
      (s) =>
        s.user.name.toLowerCase().includes(term) ||
        s.rollNumber.toLowerCase().includes(term)
    );
  }

  res.status(200).json({
    success: true,
    count: list.length,
    total: list.length,
    data: list,
  });
});

router.post('/students', (req, res) => {
  const newStudent = {
    id: `std-${Date.now()}`,
    _id: `std-${Date.now()}`,
    user: {
      _id: `usr-${Date.now()}`,
      name: req.body.name || 'New Student',
      email: req.body.email || `student${Date.now()}@college.edu`,
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      phone: req.body.phone || '',
    },
    rollNumber: req.body.rollNumber || `CSE-2023-${Math.floor(100 + Math.random() * 900)}`,
    registrationNumber: `REG-${Date.now()}`,
    department: { _id: 'dept-01', name: 'Computer Science', code: req.body.department || 'CSE' },
    course: { _id: 'crs-01', title: 'B.Tech in Computer Science', code: 'BTECH-CSE' },
    semester: Number(req.body.semester) || 1,
    section: req.body.section || 'A',
    batchYear: req.body.batchYear || '2023-2027',
    gender: req.body.gender || 'Male',
    overallAttendance: 85.0,
    cgpa: req.body.cgpa ? Number(req.body.cgpa) : 8.0,
    status: 'Active',
  };
  fakeDb.students.unshift(newStudent);
  res.status(201).json({ success: true, data: newStudent });
});

router.put('/students/:id', (req, res) => {
  const index = fakeDb.students.findIndex((s) => s.id === req.params.id || s._id === req.params.id);
  if (index !== -1) {
    if (req.body.name) fakeDb.students[index].user.name = req.body.name;
    if (req.body.rollNumber) fakeDb.students[index].rollNumber = req.body.rollNumber;
    if (req.body.semester) fakeDb.students[index].semester = Number(req.body.semester);
    if (req.body.cgpa) fakeDb.students[index].cgpa = Number(req.body.cgpa);
    return res.status(200).json({ success: true, data: fakeDb.students[index] });
  }
  res.status(404).json({ success: false, message: 'Student not found in fake DB' });
});

router.delete('/students/:id', (req, res) => {
  fakeDb.students = fakeDb.students.filter((s) => s.id !== req.params.id && s._id !== req.params.id);
  res.status(200).json({ success: true, message: 'Student deleted from fake DB' });
});

// -------------------------------------------------------------
// Faculty CRUD
// -------------------------------------------------------------
router.get('/faculty', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.faculty.length, data: fakeDb.faculty });
});

router.post('/faculty', (req, res) => {
  const newFaculty = {
    id: `fac-${Date.now()}`,
    _id: `fac-${Date.now()}`,
    user: {
      _id: `usr-${Date.now()}`,
      name: req.body.name || 'New Professor',
      email: req.body.email || `faculty${Date.now()}@college.edu`,
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
      phone: req.body.phone || '',
    },
    employeeId: req.body.employeeId || `FAC-00${fakeDb.faculty.length + 1}`,
    department: { _id: 'dept-01', name: 'Computer Science', code: req.body.department || 'CSE' },
    designation: req.body.designation || 'Assistant Professor',
    qualification: req.body.qualification || 'M.Tech / Ph.D',
    experienceYears: req.body.experienceYears ? Number(req.body.experienceYears) : 4,
    assignedSubjects: req.body.assignedSubjects || ['Data Structures'],
    salaryStatus: 'Paid',
  };
  fakeDb.faculty.unshift(newFaculty);
  res.status(201).json({ success: true, data: newFaculty });
});

router.delete('/faculty/:id', (req, res) => {
  fakeDb.faculty = fakeDb.faculty.filter((f) => f.id !== req.params.id && f._id !== req.params.id);
  res.status(200).json({ success: true, message: 'Faculty removed' });
});

// -------------------------------------------------------------
// Departments & Courses
// -------------------------------------------------------------
router.get('/departments', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.departments.length, data: fakeDb.departments });
});

router.post('/departments', (req, res) => {
  fakeDb.departments.push(req.body);
  res.status(201).json({ success: true, data: req.body });
});

router.get('/courses', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.courses.length, data: fakeDb.courses });
});

router.get('/courses/subjects/all', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.subjects.length, data: fakeDb.subjects });
});

// -------------------------------------------------------------
// Attendance
// -------------------------------------------------------------
router.post('/attendance', (req, res) => {
  // Update student attendance records in memory
  if (req.body.records && Array.isArray(req.body.records)) {
    req.body.records.forEach((rec) => {
      const student = fakeDb.students.find((s) => s.id === rec.student || s._id === rec.student);
      if (student) {
        if (rec.status === 'Absent') {
          student.overallAttendance = Math.max(50, Math.round((student.overallAttendance - 2.5) * 10) / 10);
        } else if (rec.status === 'Present') {
          student.overallAttendance = Math.min(100, Math.round((student.overallAttendance + 0.8) * 10) / 10);
        }
      }
    });
  }
  res.status(200).json({ success: true, message: 'Attendance recorded in fake DB' });
});

router.get('/attendance/student/:id', (req, res) => {
  res.status(200).json({
    success: true,
    data: {
      totalClasses: 36,
      present: 32,
      absent: 4,
      late: 0,
      overallPercentage: 88.5,
      isShortage: false,
      breakdown: [
        { subject: 'Data Structures and Algorithms', code: 'CS301', total: 36, attended: 33, percentage: 91.6, isShortage: false },
        { subject: 'Database Management Systems', code: 'CS302', total: 34, attended: 30, percentage: 88.2, isShortage: false },
        { subject: 'Computer Networks', code: 'CS303', total: 32, attended: 28, percentage: 87.5, isShortage: false },
        { subject: 'Operating Systems', code: 'CS304', total: 35, attended: 30, percentage: 85.7, isShortage: false },
      ],
    },
  });
});

// -------------------------------------------------------------
// Examinations & Results
// -------------------------------------------------------------
router.get('/exams', (req, res) => {
  res.status(200).json({
    success: true,
    data: [
      { id: 'ex-01', title: 'Semester 5 Mid-Term Examinations', examCode: 'EXAM-SEM5-MID', examType: 'Midterm', startDate: '2025-10-10', endDate: '2025-10-22', status: 'Results Published' },
      { id: 'ex-02', title: 'Semester 5 Final Theory Examination', examCode: 'EXAM-SEM5-FIN', examType: 'Final', startDate: '2025-12-05', endDate: '2025-12-18', status: 'Upcoming' },
    ],
  });
});

router.get('/exams/results/student/:id', (req, res) => {
  res.status(200).json({
    success: true,
    data: {
      results: [
        { id: 'res-01', subject: { name: 'Data Structures & Algorithms', code: 'CS301' }, marksObtained: 94, maxMarks: 100, grade: 'A+', percentage: 94, status: 'Pass', remarks: 'Outstanding problem solving' },
        { id: 'res-02', subject: { name: 'Database Management Systems', code: 'CS302' }, marksObtained: 88, maxMarks: 100, grade: 'A', percentage: 88, status: 'Pass', remarks: 'Strong relational modeling' },
        { id: 'res-03', subject: { name: 'Computer Networks', code: 'CS303' }, marksObtained: 91, maxMarks: 100, grade: 'A+', percentage: 91, status: 'Pass', remarks: 'Great packet simulations' },
        { id: 'res-04', subject: { name: 'Operating Systems', code: 'CS304' }, marksObtained: 85, maxMarks: 100, grade: 'A', percentage: 85, status: 'Pass', remarks: 'Good grasp on concurrency' },
      ],
      totalMarksObtained: 358,
      totalMaxMarks: 400,
      overallPercentage: 89.5,
      passedSubjects: 4,
      failedSubjects: 0,
    },
  });
});

router.post('/exams/results', (req, res) => {
  res.status(200).json({ success: true, message: 'Marks recorded in fake DB' });
});

// -------------------------------------------------------------
// Fees
// -------------------------------------------------------------
router.get('/fees', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.fees.length, data: fakeDb.fees });
});

router.get('/fees/student/:id', (req, res) => {
  res.status(200).json({ success: true, data: fakeDb.fees });
});

router.post('/fees/:id/pay', (req, res) => {
  const fee = fakeDb.fees.find((f) => f.id === req.params.id || f._id === req.params.id);
  if (fee) {
    const amount = Number(req.body.amount) || (fee.totalAmount - fee.paidAmount);
    fee.paidAmount += amount;
    fee.status = fee.paidAmount >= fee.totalAmount ? 'Paid' : 'Partial';
    fee.paidDate = new Date().toISOString().split('T')[0];
    fee.paymentMethod = req.body.paymentMethod || 'Online / UPI';
    fee.transactionId = `TXN-${Date.now()}`;
    fee.receiptNumber = `REC-${Math.floor(100000 + Math.random() * 900000)}`;
    return res.status(200).json({ success: true, message: 'Fee paid in fake DB', data: fee });
  }
  res.status(404).json({ success: false, message: 'Fee invoice not found' });
});

// -------------------------------------------------------------
// Timetables, Announcements & Assignments
// -------------------------------------------------------------
router.get('/timetables', (req, res) => {
  res.status(200).json({ success: true, data: fakeDb.timetables });
});

router.get('/announcements', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.announcements.length, data: fakeDb.announcements });
});

router.post('/announcements', (req, res) => {
  const newAnn = {
    id: `ann-${Date.now()}`,
    _id: `ann-${Date.now()}`,
    title: req.body.title || 'Announcement',
    content: req.body.content || '',
    priority: req.body.priority || 'medium',
    targetAudience: req.body.targetAudience || 'all',
    authorName: 'College Administration',
    publishDate: new Date().toISOString().split('T')[0],
    date: new Date().toISOString().split('T')[0],
    isActive: true,
  };
  fakeDb.announcements.unshift(newAnn);
  res.status(201).json({ success: true, data: newAnn });
});

router.get('/assignments', (req, res) => {
  res.status(200).json({ success: true, count: fakeDb.assignments.length, data: fakeDb.assignments });
});

router.post('/assignments', (req, res) => {
  const newAsg = {
    id: `asg-${Date.now()}`,
    _id: `asg-${Date.now()}`,
    title: req.body.title || 'Assignment',
    description: req.body.description || '',
    subject: { name: 'Data Structures and Algorithms', code: 'CS301' },
    faculty: { user: { name: 'Prof. Robert C. Martin' } },
    totalMarks: req.body.totalMarks ? Number(req.body.totalMarks) : 20,
    dueDate: req.body.dueDate || '2025-11-25',
  };
  fakeDb.assignments.unshift(newAsg);
  res.status(201).json({ success: true, data: newAsg });
});

router.post('/assignments/:id/submit', (req, res) => {
  res.status(200).json({ success: true, message: 'Assignment submitted in fake DB' });
});

module.exports = router;
