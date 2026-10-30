const mongoose = require('mongoose');

const PeriodSchema = new mongoose.Schema({
  periodNumber: {
    type: Number,
    required: true,
  },
  startTime: {
    type: String,
    required: true, // e.g. "09:00 AM"
  },
  endTime: {
    type: String,
    required: true, // e.g. "10:00 AM"
  },
  subject: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Subject',
    required: true,
  },
  faculty: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Faculty',
    required: true,
  },
  roomNumber: {
    type: String,
    default: 'Room 101',
  },
});

const TimetableSchema = new mongoose.Schema(
  {
    department: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Department',
      required: true,
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Course',
    },
    semester: {
      type: Number,
      required: true,
    },
    section: {
      type: String,
      required: true,
    },
    dayOfWeek: {
      type: String,
      enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      required: true,
    },
    periods: [PeriodSchema],
  },
  { timestamps: true }
);

module.exports = mongoose.model('Timetable', TimetableSchema);

