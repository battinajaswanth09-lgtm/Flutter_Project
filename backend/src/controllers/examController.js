const Examination = require('../models/Examination');
const Result = require('../models/Result');

// Exams
exports.getExams = async (req, res, next) => {
  try {
    const { department, semester } = req.query;
    const query = {};
    if (department) query.department = department;
    if (semester) query.semester = Number(semester);

    const exams = await Examination.find(query).populate('department', 'name code').sort({ startDate: -1 });
    res.status(200).json({ success: true, count: exams.length, data: exams });
  } catch (err) {
    next(err);
  }
};

exports.createExam = async (req, res, next) => {
  try {
    const exam = await Examination.create(req.body);
    res.status(201).json({ success: true, data: exam });
  } catch (err) {
    next(err);
  }
};

// Results
exports.submitMarks = async (req, res, next) => {
  try {
    const { examination, student, subject, marksObtained, maxMarks, remarks } = req.body;

    let result = await Result.findOne({ examination, student, subject });
    if (result) {
      result.marksObtained = marksObtained;
      if (maxMarks) result.maxMarks = maxMarks;
      if (remarks) result.remarks = remarks;
      await result.save();
    } else {
      result = await Result.create({
        examination,
        student,
        subject,
        marksObtained,
        maxMarks: maxMarks || 100,
        remarks: remarks || '',
      });
    }

    const populated = await Result.findById(result._id)
      .populate('examination', 'title examCode examType')
      .populate('subject', 'name code credits')
      .populate({
        path: 'student',
        populate: { path: 'user', select: 'name email' },
      });

    res.status(200).json({ success: true, data: populated });
  } catch (err) {
    next(err);
  }
};

exports.getStudentResults = async (req, res, next) => {
  try {
    const studentId = req.params.studentId;
    const results = await Result.find({ student: studentId })
      .populate('examination', 'title examCode examType semester')
      .populate('subject', 'name code credits')
      .sort({ createdAt: -1 });

    let totalMarksObtained = 0;
    let totalMaxMarks = 0;

    results.forEach((r) => {
      totalMarksObtained += r.marksObtained;
      totalMaxMarks += r.maxMarks;
    });

    const overallPercentage = totalMaxMarks > 0 ? Math.round((totalMarksObtained / totalMaxMarks) * 100) : 0;

    res.status(200).json({
      success: true,
      data: {
        results,
        totalMarksObtained,
        totalMaxMarks,
        overallPercentage,
        passedSubjects: results.filter((r) => r.status === 'Pass').length,
        failedSubjects: results.filter((r) => r.status === 'Fail').length,
      },
    });
  } catch (err) {
    next(err);
  }
};
