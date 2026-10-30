const Student = require('../models/Student');
const User = require('../models/User');
const Attendance = require('../models/Attendance');
const Result = require('../models/Result');
const Fee = require('../models/Fee');

// @desc    Get all students with search & filter & pagination
// @route   GET /api/students
// @access  Private (Admin, Faculty)
exports.getAllStudents = async (req, res, next) => {
  try {
    const { department, semester, section, search, page = 1, limit = 20 } = req.query;

    const query = {};

    if (department) query.department = department;
    if (semester) query.semester = Number(semester);
    if (section) query.section = section.toUpperCase();

    // Student find with populate
    let studentQuery = Student.find(query)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('course', 'title code');

    let students = await studentQuery;

    // Filter by name or roll number if search term provided
    if (search && search.trim() !== '') {
      const term = search.toLowerCase().trim();
      students = students.filter(
        (s) =>
          (s.user && s.user.name.toLowerCase().includes(term)) ||
          (s.rollNumber && s.rollNumber.toLowerCase().includes(term)) ||
          (s.registrationNumber && s.registrationNumber.toLowerCase().includes(term))
      );
    }

    const total = students.length;
    const startIndex = (Number(page) - 1) * Number(limit);
    const paginatedStudents = students.slice(startIndex, startIndex + Number(limit));

    res.status(200).json({
      success: true,
      count: paginatedStudents.length,
      total,
      currentPage: Number(page),
      totalPages: Math.ceil(total / Number(limit)),
      data: paginatedStudents,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single student by ID
// @route   GET /api/students/:id
// @access  Private
exports.getStudentById = async (req, res, next) => {
  try {
    const student = await Student.findById(req.params.id)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('course', 'title code');

    if (!student) {
      return res.status(404).json({
        success: false,
        message: 'Student not found',
      });
    }

    res.status(200).json({
      success: true,
      data: student,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new student (Admin)
// @route   POST /api/students
// @access  Private (Admin)
exports.createStudent = async (req, res, next) => {
  try {
    const {
      name,
      email,
      password,
      rollNumber,
      registrationNumber,
      department,
      course,
      semester,
      section,
      batchYear,
      gender,
      dateOfBirth,
      bloodGroup,
      address,
      guardianName,
      guardianPhone,
      phone,
    } = req.body;

    // 1. Create User
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'A user with this email address already exists',
      });
    }

    const user = await User.create({
      name,
      email,
      password: password || 'Student@123',
      role: 'student',
      phone: phone || '',
    });

    // 2. Create Student linked to User
    const student = await Student.create({
      user: user._id,
      rollNumber,
      registrationNumber: registrationNumber || `REG-${Date.now()}`,
      department,
      course,
      semester: semester || 1,
      section: section || 'A',
      batchYear: batchYear || '2023-2027',
      gender: gender || 'Male',
      dateOfBirth,
      bloodGroup,
      address,
      guardianName,
      guardianPhone,
    });

    const populatedStudent = await Student.findById(student._id)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('course', 'title code');

    res.status(201).json({
      success: true,
      message: 'Student created successfully',
      data: populatedStudent,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update student details
// @route   PUT /api/students/:id
// @access  Private (Admin)
exports.updateStudent = async (req, res, next) => {
  try {
    const student = await Student.findById(req.params.id);
    if (!student) {
      return res.status(404).json({ success: false, message: 'Student not found' });
    }

    // Update user details if provided
    if (req.body.name || req.body.phone || req.body.avatar) {
      await User.findByIdAndUpdate(student.user, {
        name: req.body.name,
        phone: req.body.phone,
        avatar: req.body.avatar,
      });
    }

    // Update student fields
    const updatedStudent = await Student.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    )
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('course', 'title code');

    res.status(200).json({
      success: true,
      message: 'Student updated successfully',
      data: updatedStudent,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete student
// @route   DELETE /api/students/:id
// @access  Private (Admin)
exports.deleteStudent = async (req, res, next) => {
  try {
    const student = await Student.findById(req.params.id);
    if (!student) {
      return res.status(404).json({ success: false, message: 'Student not found' });
    }

    await User.findByIdAndDelete(student.user);
    await Student.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Student and linked user account deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get logged in student's complete dashboard overview
// @route   GET /api/students/me/overview
// @access  Private (Student)
exports.getMyOverview = async (req, res, next) => {
  try {
    const student = await Student.findOne({ user: req.user._id })
      .populate('user', 'name email avatar phone')
      .populate('department', 'name code')
      .populate('course', 'title code');

    if (!student) {
      return res.status(404).json({ success: false, message: 'Student profile not found' });
    }

    const fees = await Fee.find({ student: student._id });
    const results = await Result.find({ student: student._id }).populate('subject', 'name code');

    res.status(200).json({
      success: true,
      data: {
        student,
        fees,
        results,
      },
    });
  } catch (err) {
    next(err);
  }
};
