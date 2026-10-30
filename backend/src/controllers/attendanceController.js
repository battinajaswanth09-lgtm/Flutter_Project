const Attendance = require('../models/Attendance');
const Student = require('../models/Student');

// @desc    Mark attendance for a class/subject
// @route   POST /api/attendance
// @access  Private (Faculty, Admin)
exports.markAttendance = async (req, res, next) => {
  try {
    const { subject, faculty, department, date, semester, section, records } = req.body;

    const attendanceDate = date ? new Date(date) : new Date();
    attendanceDate.setHours(0, 0, 0, 0);

    // Check if attendance already recorded for this subject, section, and date
    let attendance = await Attendance.findOne({
      subject,
      semester,
      section,
      date: {
        $gte: attendanceDate,
        $lt: new Date(attendanceDate.getTime() + 24 * 60 * 60 * 1000),
      },
    });

    if (attendance) {
      attendance.records = records;
      attendance.faculty = faculty || attendance.faculty;
      await attendance.save();
    } else {
      attendance = await Attendance.create({
        subject,
        faculty,
        department,
        date: attendanceDate,
        semester,
        section,
        records,
      });
    }

    // Update overallAttendance cache on students
    for (const record of records) {
      const studentId = record.student;
      const allStudentRecords = await Attendance.find({ 'records.student': studentId });
      let totalClasses = 0;
      let attendedClasses = 0;

      allStudentRecords.forEach((att) => {
        const item = att.records.find((r) => r.student.toString() === studentId.toString());
        if (item) {
          totalClasses++;
          if (item.status === 'Present' || item.status === 'Late') {
            attendedClasses++;
          }
        }
      });

      if (totalClasses > 0) {
        const percentage = Math.round((attendedClasses / totalClasses) * 100);
        await Student.findByIdAndUpdate(studentId, { overallAttendance: percentage });
      }
    }

    res.status(200).json({
      success: true,
      message: 'Attendance saved successfully',
      data: attendance,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get attendance by subject and date
// @route   GET /api/attendance
// @access  Private
exports.getAttendance = async (req, res, next) => {
  try {
    const { subject, semester, section, date } = req.query;
    const query = {};

    if (subject) query.subject = subject;
    if (semester) query.semester = Number(semester);
    if (section) query.section = section;

    if (date) {
      const d = new Date(date);
      d.setHours(0, 0, 0, 0);
      query.date = {
        $gte: d,
        $lt: new Date(d.getTime() + 24 * 60 * 60 * 1000),
      };
    }

    const records = await Attendance.find(query)
      .populate('subject', 'name code')
      .populate('records.student')
      .populate({
        path: 'records.student',
        populate: { path: 'user', select: 'name email rollNumber' },
      })
      .sort({ date: -1 });

    res.status(200).json({ success: true, count: records.length, data: records });
  } catch (err) {
    next(err);
  }
};

// @desc    Get student's own attendance summary
// @route   GET /api/attendance/student/:studentId
// @access  Private
exports.getStudentAttendanceSummary = async (req, res, next) => {
  try {
    const studentId = req.params.studentId;
    const records = await Attendance.find({ 'records.student': studentId })
      .populate('subject', 'name code')
      .sort({ date: -1 });

    let total = 0;
    let present = 0;
    let absent = 0;
    let late = 0;

    const subjectBreakdown = {};

    records.forEach((att) => {
      const rec = att.records.find((r) => r.student.toString() === studentId.toString());
      if (rec) {
        total++;
        if (rec.status === 'Present') present++;
        else if (rec.status === 'Absent') absent++;
        else if (rec.status === 'Late') late++;

        const subName = att.subject ? att.subject.name : 'Unknown';
        if (!subjectBreakdown[subName]) {
          subjectBreakdown[subName] = { total: 0, attended: 0, subjectCode: att.subject?.code };
        }
        subjectBreakdown[subName].total++;
        if (rec.status === 'Present' || rec.status === 'Late') {
          subjectBreakdown[subName].attended++;
        }
      }
    });

    const overallPercentage = total > 0 ? Math.round(((present + late) / total) * 100) : 100;

    const breakdownArray = Object.keys(subjectBreakdown).map((key) => {
      const item = subjectBreakdown[key];
      const pct = item.total > 0 ? Math.round((item.attended / item.total) * 100) : 100;
      return {
        subject: key,
        code: item.subjectCode,
        total: item.total,
        attended: item.attended,
        percentage: pct,
        isShortage: pct < 75,
      };
    });

    res.status(200).json({
      success: true,
      data: {
        totalClasses: total,
        present,
        absent,
        late,
        overallPercentage,
        isShortage: overallPercentage < 75,
        breakdown: breakdownArray,
      },
    });
  } catch (err) {
    next(err);
  }
};
