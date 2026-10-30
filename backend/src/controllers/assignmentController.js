const Assignment = require('../models/Assignment');
const Faculty = require('../models/Faculty');

// @desc    Get assignments for a class / semester
// @route   GET /api/assignments
// @access  Private
exports.getAssignments = async (req, res, next) => {
  try {
    const { semester, department, subject } = req.query;
    const query = {};
    if (semester) query.semester = Number(semester);
    if (department) query.department = department;
    if (subject) query.subject = subject;

    const assignments = await Assignment.find(query)
      .populate('subject', 'name code')
      .populate({
        path: 'faculty',
        populate: { path: 'user', select: 'name' },
      })
      .sort({ dueDate: 1 });

    res.status(200).json({ success: true, count: assignments.length, data: assignments });
  } catch (err) {
    next(err);
  }
};

// @desc    Create new assignment (Faculty)
// @route   POST /api/assignments
// @access  Private (Faculty, Admin)
exports.createAssignment = async (req, res, next) => {
  try {
    const { title, description, subject, department, semester, section, totalMarks, dueDate, attachmentUrl } = req.body;

    let facultyId = req.body.faculty;
    if (!facultyId && req.user.role === 'faculty') {
      const fac = await Faculty.findOne({ user: req.user._id });
      if (fac) facultyId = fac._id;
    }

    const assignment = await Assignment.create({
      title,
      description,
      subject,
      faculty: facultyId,
      department,
      semester,
      section: section || 'A',
      totalMarks: totalMarks || 20,
      dueDate,
      attachmentUrl: attachmentUrl || '',
    });

    const populated = await Assignment.findById(assignment._id).populate('subject', 'name code');
    res.status(201).json({ success: true, data: populated });
  } catch (err) {
    next(err);
  }
};

// @desc    Submit assignment (Student)
// @route   POST /api/assignments/:id/submit
// @access  Private (Student)
exports.submitAssignment = async (req, res, next) => {
  try {
    const { fileUrl, notes, studentId } = req.body;
    const assignment = await Assignment.findById(req.params.id);

    if (!assignment) {
      return res.status(404).json({ success: false, message: 'Assignment not found' });
    }

    const existingIndex = assignment.submissions.findIndex(
      (s) => s.student.toString() === studentId.toString()
    );

    if (existingIndex > -1) {
      assignment.submissions[existingIndex].fileUrl = fileUrl || assignment.submissions[existingIndex].fileUrl;
      assignment.submissions[existingIndex].notes = notes || assignment.submissions[existingIndex].notes;
      assignment.submissions[existingIndex].submissionDate = new Date();
    } else {
      assignment.submissions.push({
        student: studentId,
        fileUrl,
        notes,
        submissionDate: new Date(),
      });
    }

    await assignment.save();
    res.status(200).json({ success: true, message: 'Assignment submitted successfully' });
  } catch (err) {
    next(err);
  }
};

