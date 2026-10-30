const Course = require('../models/Course');
const Subject = require('../models/Subject');

// Courses
exports.getCourses = async (req, res, next) => {
  try {
    const { department } = req.query;
    const query = department ? { department } : {};
    const courses = await Course.find(query).populate('department', 'name code');
    res.status(200).json({ success: true, count: courses.length, data: courses });
  } catch (err) {
    next(err);
  }
};

exports.createCourse = async (req, res, next) => {
  try {
    const course = await Course.create(req.body);
    const populated = await Course.findById(course._id).populate('department', 'name code');
    res.status(201).json({ success: true, data: populated });
  } catch (err) {
    next(err);
  }
};

exports.updateCourse = async (req, res, next) => {
  try {
    const course = await Course.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    }).populate('department', 'name code');
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });
    res.status(200).json({ success: true, data: course });
  } catch (err) {
    next(err);
  }
};

exports.deleteCourse = async (req, res, next) => {
  try {
    const course = await Course.findByIdAndDelete(req.params.id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });
    res.status(200).json({ success: true, message: 'Course removed' });
  } catch (err) {
    next(err);
  }
};

// Subjects
exports.getSubjects = async (req, res, next) => {
  try {
    const { department, course, semester } = req.query;
    const query = {};
    if (department) query.department = department;
    if (course) query.course = course;
    if (semester) query.semester = Number(semester);

    const subjects = await Subject.find(query)
      .populate('department', 'name code')
      .populate('course', 'title code')
      .populate({
        path: 'faculty',
        populate: { path: 'user', select: 'name email' },
      });

    res.status(200).json({ success: true, count: subjects.length, data: subjects });
  } catch (err) {
    next(err);
  }
};

exports.createSubject = async (req, res, next) => {
  try {
    const subject = await Subject.create(req.body);
    res.status(201).json({ success: true, data: subject });
  } catch (err) {
    next(err);
  }
};

exports.updateSubject = async (req, res, next) => {
  try {
    const subject = await Subject.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!subject) return res.status(404).json({ success: false, message: 'Subject not found' });
    res.status(200).json({ success: true, data: subject });
  } catch (err) {
    next(err);
  }
};

exports.deleteSubject = async (req, res, next) => {
  try {
    const subject = await Subject.findByIdAndDelete(req.params.id);
    if (!subject) return res.status(404).json({ success: false, message: 'Subject not found' });
    res.status(200).json({ success: true, message: 'Subject deleted' });
  } catch (err) {
    next(err);
  }
};
