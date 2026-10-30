const Faculty = require('../models/Faculty');
const User = require('../models/User');
const Subject = require('../models/Subject');

// @desc    Get all faculty members with pagination & search
// @route   GET /api/faculty
// @access  Private (Admin, Faculty)
exports.getAllFaculty = async (req, res, next) => {
  try {
    const { department, search, page = 1, limit = 20 } = req.query;
    const query = {};

    if (department) query.department = department;

    let facultyList = await Faculty.find(query)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('assignedSubjects', 'name code semester');

    if (search && search.trim() !== '') {
      const term = search.toLowerCase().trim();
      facultyList = facultyList.filter(
        (f) =>
          (f.user && f.user.name.toLowerCase().includes(term)) ||
          (f.employeeId && f.employeeId.toLowerCase().includes(term)) ||
          (f.designation && f.designation.toLowerCase().includes(term))
      );
    }

    const total = facultyList.length;
    const startIndex = (Number(page) - 1) * Number(limit);
    const paginated = facultyList.slice(startIndex, startIndex + Number(limit));

    res.status(200).json({
      success: true,
      count: paginated.length,
      total,
      currentPage: Number(page),
      totalPages: Math.ceil(total / Number(limit)),
      data: paginated,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single faculty by ID
// @route   GET /api/faculty/:id
// @access  Private
exports.getFacultyById = async (req, res, next) => {
  try {
    const faculty = await Faculty.findById(req.params.id)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('assignedSubjects', 'name code semester');

    if (!faculty) {
      return res.status(404).json({ success: false, message: 'Faculty not found' });
    }

    res.status(200).json({
      success: true,
      data: faculty,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new faculty member
// @route   POST /api/faculty
// @access  Private (Admin)
exports.createFaculty = async (req, res, next) => {
  try {
    const {
      name,
      email,
      password,
      employeeId,
      department,
      designation,
      qualification,
      specialization,
      assignedSubjects,
      experienceYears,
      phone,
    } = req.body;

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
      password: password || 'Faculty@123',
      role: 'faculty',
      phone: phone || '',
    });

    const faculty = await Faculty.create({
      user: user._id,
      employeeId,
      department,
      designation: designation || 'Assistant Professor',
      qualification: qualification || 'M.Tech / Ph.D',
      specialization: specialization || 'Computer Science',
      assignedSubjects: assignedSubjects || [],
      experienceYears: experienceYears || 3,
    });

    const populatedFaculty = await Faculty.findById(faculty._id)
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('assignedSubjects', 'name code semester');

    res.status(201).json({
      success: true,
      message: 'Faculty created successfully',
      data: populatedFaculty,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update faculty member
// @route   PUT /api/faculty/:id
// @access  Private (Admin)
exports.updateFaculty = async (req, res, next) => {
  try {
    const faculty = await Faculty.findById(req.params.id);
    if (!faculty) {
      return res.status(404).json({ success: false, message: 'Faculty not found' });
    }

    if (req.body.name || req.body.phone || req.body.avatar) {
      await User.findByIdAndUpdate(faculty.user, {
        name: req.body.name,
        phone: req.body.phone,
        avatar: req.body.avatar,
      });
    }

    const updated = await Faculty.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    })
      .populate('user', 'name email avatar phone isActive')
      .populate('department', 'name code')
      .populate('assignedSubjects', 'name code semester');

    res.status(200).json({
      success: true,
      message: 'Faculty updated successfully',
      data: updated,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete faculty member
// @route   DELETE /api/faculty/:id
// @access  Private (Admin)
exports.deleteFaculty = async (req, res, next) => {
  try {
    const faculty = await Faculty.findById(req.params.id);
    if (!faculty) {
      return res.status(404).json({ success: false, message: 'Faculty not found' });
    }

    await User.findByIdAndDelete(faculty.user);
    await Faculty.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Faculty and user account deleted successfully',
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get faculty dashboard overview
// @route   GET /api/faculty/me/overview
// @access  Private (Faculty)
exports.getMyFacultyOverview = async (req, res, next) => {
  try {
    const faculty = await Faculty.findOne({ user: req.user._id })
      .populate('user', 'name email avatar phone')
      .populate('department', 'name code')
      .populate('assignedSubjects', 'name code semester credits');

    if (!faculty) {
      return res.status(404).json({ success: false, message: 'Faculty profile not found' });
    }

    res.status(200).json({
      success: true,
      data: faculty,
    });
  } catch (err) {
    next(err);
  }
};

