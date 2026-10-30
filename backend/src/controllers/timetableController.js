const Timetable = require('../models/Timetable');

// @desc    Get timetable by department, semester, section
// @route   GET /api/timetables
// @access  Private
exports.getTimetable = async (req, res, next) => {
  try {
    const { department, semester, section } = req.query;
    const query = {};
    if (department) query.department = department;
    if (semester) query.semester = Number(semester);
    if (section) query.section = section;

    const timetables = await Timetable.find(query)
      .populate('department', 'name code')
      .populate('periods.subject', 'name code')
      .populate({
        path: 'periods.faculty',
        populate: { path: 'user', select: 'name' },
      });

    res.status(200).json({ success: true, data: timetables });
  } catch (err) {
    next(err);
  }
};

// @desc    Create or update day's schedule
// @route   POST /api/timetables
// @access  Private (Admin)
exports.saveTimetable = async (req, res, next) => {
  try {
    const { department, course, semester, section, dayOfWeek, periods } = req.body;

    let timetable = await Timetable.findOne({
      department,
      semester,
      section,
      dayOfWeek,
    });

    if (timetable) {
      timetable.periods = periods;
      await timetable.save();
    } else {
      timetable = await Timetable.create({
        department,
        course,
        semester,
        section,
        dayOfWeek,
        periods,
      });
    }

    const populated = await Timetable.findById(timetable._id)
      .populate('department', 'name code')
      .populate('periods.subject', 'name code')
      .populate({
        path: 'periods.faculty',
        populate: { path: 'user', select: 'name' },
      });

    res.status(200).json({ success: true, data: populated });
  } catch (err) {
    next(err);
  }
};

