const mongoose = require('mongoose');
require('dotenv').config();

const User = require('../models/User');
const Department = require('../models/Department');
const Course = require('../models/Course');
const Subject = require('../models/Subject');
const Student = require('../models/Student');
const Faculty = require('../models/Faculty');
const Fee = require('../models/Fee');
const Examination = require('../models/Examination');
const Result = require('../models/Result');
const Announcement = require('../models/Announcement');
const Timetable = require('../models/Timetable');
const Assignment = require('../models/Assignment');

const seedData = async () => {
  try {
    const connUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/college_management';
    await mongoose.connect(connUri);
    console.log('[Seed] Connected to database');

    // Clean previous records
    await Promise.all([
      User.deleteMany(),
      Department.deleteMany(),
      Course.deleteMany(),
      Subject.deleteMany(),
      Student.deleteMany(),
      Faculty.deleteMany(),
      Fee.deleteMany(),
      Examination.deleteMany(),
      Result.deleteMany(),
      Announcement.deleteMany(),
      Timetable.deleteMany(),
      Assignment.deleteMany(),
    ]);
    console.log('[Seed] Cleared old collections');

    // 1. Create Admin User
    const adminUser = await User.create({
      name: 'System Administrator',
      email: 'admin@college.edu',
      password: 'AdminPassword123!',
      role: 'admin',
      phone: '+1 (555) 019-2834',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=250&q=80',
    });

    // 2. Create Departments
    const deptCSE = await Department.create({
      name: 'Computer Science and Engineering',
      code: 'CSE',
      description: 'Department of Computing, Artificial Intelligence & Software Systems',
      headOfDepartment: 'Dr. Alan Turing',
      establishedYear: 2004,
      contactEmail: 'cse@college.edu',
      phone: '+1 555-101-2001',
    });

    const deptECE = await Department.create({
      name: 'Electronics and Communication Engineering',
      code: 'ECE',
      description: 'Department of Microelectronics, Embedded Systems & Signal Processing',
      headOfDepartment: 'Dr. Claude Shannon',
      establishedYear: 2006,
      contactEmail: 'ece@college.edu',
      phone: '+1 555-101-2002',
    });

    const deptME = await Department.create({
      name: 'Mechanical Engineering',
      code: 'MECH',
      description: 'Department of Robotics, Thermodynamics & Manufacturing',
      headOfDepartment: 'Dr. Nikola Tesla',
      establishedYear: 2002,
      contactEmail: 'mech@college.edu',
      phone: '+1 555-101-2003',
    });

    // 3. Create Courses
    const courseBTechCSE = await Course.create({
      title: 'Bachelor of Technology in Computer Science',
      code: 'BTECH-CSE',
      department: deptCSE._id,
      durationYears: 4,
      totalSemesters: 8,
      credits: 160,
      description: 'Undergraduate professional degree in Computer Engineering and Software Architecture.',
    });

    const courseBTechECE = await Course.create({
      title: 'Bachelor of Technology in Electronics',
      code: 'BTECH-ECE',
      department: deptECE._id,
      durationYears: 4,
      totalSemesters: 8,
      credits: 160,
      description: 'Comprehensive degree covering VLSI design, communication circuits and IoT.',
    });

    // 4. Create Faculty Users & Profiles
    const facultyUser1 = await User.create({
      name: 'Prof. Robert C. Martin',
      email: 'faculty@college.edu',
      password: 'FacultyPassword123!',
      role: 'faculty',
      phone: '+1 (555) 345-9821',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
    });

    const facultyProfile1 = await Faculty.create({
      user: facultyUser1._id,
      employeeId: 'FAC-CSE-001',
      department: deptCSE._id,
      designation: 'Professor',
      qualification: 'Ph.D. in Computer Science',
      specialization: 'Software Architecture & Cloud Computing',
      experienceYears: 12,
    });

    const facultyUser2 = await User.create({
      name: 'Dr. Grace Hopper',
      email: 'grace.hopper@college.edu',
      password: 'FacultyPassword123!',
      role: 'faculty',
      phone: '+1 (555) 789-1122',
      avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=250&q=80',
    });

    const facultyProfile2 = await Faculty.create({
      user: facultyUser2._id,
      employeeId: 'FAC-CSE-002',
      department: deptCSE._id,
      designation: 'Associate Professor',
      qualification: 'Ph.D. in Compiler Design',
      specialization: 'Programming Languages & Algorithms',
      experienceYears: 9,
    });

    // 5. Create Subjects
    const subDSA = await Subject.create({
      name: 'Data Structures and Algorithms',
      code: 'CS301',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      credits: 4,
      faculty: facultyProfile1._id,
    });

    const subDBMS = await Subject.create({
      name: 'Database Management Systems',
      code: 'CS302',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      credits: 4,
      faculty: facultyProfile2._id,
    });

    const subCN = await Subject.create({
      name: 'Computer Networks',
      code: 'CS303',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      credits: 3,
      faculty: facultyProfile1._id,
    });

    const subOS = await Subject.create({
      name: 'Operating Systems',
      code: 'CS304',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      credits: 4,
      faculty: facultyProfile2._id,
    });

    // Link subjects to faculty
    facultyProfile1.assignedSubjects = [subDSA._id, subCN._id];
    facultyProfile1.assignedClasses = [{ semester: 5, section: 'A' }];
    await facultyProfile1.save();

    facultyProfile2.assignedSubjects = [subDBMS._id, subOS._id];
    facultyProfile2.assignedClasses = [{ semester: 5, section: 'A' }];
    await facultyProfile2.save();

    // 6. Create Student Users & Profiles
    const studentUser1 = await User.create({
      name: 'Alex Johnson',
      email: 'student@college.edu',
      password: 'StudentPassword123!',
      role: 'student',
      phone: '+1 (555) 432-8765',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
    });

    const studentProfile1 = await Student.create({
      user: studentUser1._id,
      rollNumber: 'CSE-2023-042',
      registrationNumber: 'REG-2023-90812',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      section: 'A',
      batchYear: '2023-2027',
      gender: 'Female',
      dateOfBirth: new Date('2003-05-14'),
      bloodGroup: 'B+',
      address: '742 Evergreen Terrace, Tech Park City',
      guardianName: 'Mark Johnson',
      guardianPhone: '+1 (555) 432-8700',
      overallAttendance: 88.5,
      cgpa: 8.75,
      status: 'Active',
    });

    const studentUser2 = await User.create({
      name: 'Ethan Hunt',
      email: 'ethan.hunt@college.edu',
      password: 'StudentPassword123!',
      role: 'student',
      phone: '+1 (555) 234-9012',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=250&q=80',
    });

    const studentProfile2 = await Student.create({
      user: studentUser2._id,
      rollNumber: 'CSE-2023-018',
      registrationNumber: 'REG-2023-90813',
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      section: 'A',
      batchYear: '2023-2027',
      gender: 'Male',
      dateOfBirth: new Date('2003-09-21'),
      bloodGroup: 'O+',
      address: '12 Mission Way, Downtown',
      guardianName: 'William Hunt',
      guardianPhone: '+1 (555) 234-9000',
      overallAttendance: 71.0, // Shortage alert example!
      cgpa: 7.9,
      status: 'Active',
    });

    // 7. Create Announcements
    await Announcement.create([
      {
        title: 'Mid-Term Examinations Schedule Released',
        content: 'The Semester 5 Mid-term Examinations will commence from 15th of next month. Students are advised to verify hall tickets.',
        targetAudience: 'all',
        priority: 'high',
        author: adminUser._id,
        authorName: 'College Administration',
      },
      {
        title: 'Annual Tech Fest "TechNovation 2026" Registrations Open',
        content: 'Hackathons, coding relays, robotics battle, and guest lectures from industry leaders. Register through student portal.',
        targetAudience: 'student',
        priority: 'medium',
        author: adminUser._id,
        authorName: 'Student Affairs Council',
      },
      {
        title: 'Faculty Curriculum Development Workshop',
        content: 'Mandatory workshop on AI integration in engineering pedagogy scheduled for this Saturday at Conference Hall B.',
        targetAudience: 'faculty',
        priority: 'high',
        author: adminUser._id,
        authorName: 'Dean of Academics',
      },
    ]);

    // 8. Create Timetable
    await Timetable.create({
      department: deptCSE._id,
      course: courseBTechCSE._id,
      semester: 5,
      section: 'A',
      dayOfWeek: 'Monday',
      periods: [
        {
          periodNumber: 1,
          startTime: '09:00 AM',
          endTime: '10:00 AM',
          subject: subDSA._id,
          faculty: facultyProfile1._id,
          roomNumber: 'LH-301',
        },
        {
          periodNumber: 2,
          startTime: '10:00 AM',
          endTime: '11:00 AM',
          subject: subDBMS._id,
          faculty: facultyProfile2._id,
          roomNumber: 'LH-301',
        },
        {
          periodNumber: 3,
          startTime: '11:15 AM',
          endTime: '12:15 PM',
          subject: subCN._id,
          faculty: facultyProfile1._id,
          roomNumber: 'LH-204',
        },
        {
          periodNumber: 4,
          startTime: '01:30 PM',
          endTime: '03:30 PM',
          subject: subDSA._id,
          faculty: facultyProfile1._id,
          roomNumber: 'Software Lab 2',
        },
      ],
    });

    // 9. Create Examinations & Results
    const examMidterm = await Examination.create({
      title: 'Fifth Semester Mid-Term Examination 2025-26',
      examCode: 'EXAM-SEM5-MID-2025',
      examType: 'Midterm',
      academicYear: '2025-2026',
      semester: 5,
      department: deptCSE._id,
      startDate: new Date('2025-10-10'),
      endDate: new Date('2025-10-22'),
      status: 'Results Published',
    });

    await Result.create([
      {
        examination: examMidterm._id,
        student: studentProfile1._id,
        subject: subDSA._id,
        marksObtained: 94,
        maxMarks: 100,
        remarks: 'Excellent problem solving',
      },
      {
        examination: examMidterm._id,
        student: studentProfile1._id,
        subject: subDBMS._id,
        marksObtained: 88,
        maxMarks: 100,
        remarks: 'Strong relational modeling skills',
      },
      {
        examination: examMidterm._id,
        student: studentProfile1._id,
        subject: subCN._id,
        marksObtained: 91,
        maxMarks: 100,
        remarks: 'Great packet tracer simulations',
      },
      {
        examination: examMidterm._id,
        student: studentProfile1._id,
        subject: subOS._id,
        marksObtained: 85,
        maxMarks: 100,
        remarks: 'Good grasp on concurrency',
      },
      // Student 2 results
      {
        examination: examMidterm._id,
        student: studentProfile2._id,
        subject: subDSA._id,
        marksObtained: 72,
        maxMarks: 100,
        remarks: 'Practice graph algorithms',
      },
      {
        examination: examMidterm._id,
        student: studentProfile2._id,
        subject: subDBMS._id,
        marksObtained: 68,
        maxMarks: 100,
        remarks: 'Review normalization',
      },
    ]);

    // 10. Create Fee Records
    await Fee.create([
      {
        student: studentProfile1._id,
        title: 'Semester 5 Tuition & Campus Facility Fee',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Tuition',
        totalAmount: 45000,
        paidAmount: 45000,
        dueDate: new Date('2025-09-01'),
        paidDate: new Date('2025-08-25'),
        paymentMethod: 'Online / UPI',
        transactionId: 'UPI-TXN-902847192',
        receiptNumber: 'REC-2025-8819',
        status: 'Paid',
      },
      {
        student: studentProfile1._id,
        title: 'Annual Library & Digital Resources Subscription',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Library',
        totalAmount: 3500,
        paidAmount: 3500,
        dueDate: new Date('2025-09-15'),
        paidDate: new Date('2025-09-10'),
        paymentMethod: 'Credit/Debit Card',
        transactionId: 'CARD-TXN-382910',
        receiptNumber: 'REC-2025-9014',
        status: 'Paid',
      },
      {
        student: studentProfile2._id,
        title: 'Semester 5 Tuition Fee',
        academicYear: '2025-2026',
        semester: 5,
        feeType: 'Tuition',
        totalAmount: 45000,
        paidAmount: 15000,
        dueDate: new Date('2025-11-15'),
        status: 'Partial',
      },
    ]);

    // 11. Create Assignments
    await Assignment.create([
      {
        title: 'Binary Search Tree & AVL Tree Implementation',
        description: 'Implement AVL rotation algorithms and self-balancing checks in Dart or C++. Include benchmark comparisons.',
        subject: subDSA._id,
        faculty: facultyProfile1._id,
        department: deptCSE._id,
        semester: 5,
        section: 'A',
        totalMarks: 25,
        dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      },
      {
        title: 'Query Optimization & B-Tree Index Analysis',
        description: 'Analyze EXPLAIN plan on 500k dataset records using MongoDB/Postgres. Submit PDF with metrics.',
        subject: subDBMS._id,
        faculty: facultyProfile2._id,
        department: deptCSE._id,
        semester: 5,
        section: 'A',
        totalMarks: 20,
        dueDate: new Date(Date.now() + 12 * 24 * 60 * 60 * 1000),
      },
    ]);

    console.log('[Seed] Database seeded successfully!');
    console.log('----------------------------------------------------');
    console.log('Sample Credentials for Testing:');
    console.log('ADMIN:   email: admin@college.edu     pass: AdminPassword123!');
    console.log('FACULTY: email: faculty@college.edu   pass: FacultyPassword123!');
    console.log('STUDENT: email: student@college.edu   pass: StudentPassword123!');
    console.log('----------------------------------------------------');

    process.exit(0);
  } catch (err) {
    console.error('[Seed] Error seeding data:', err);
    process.exit(1);
  }
};

seedData();
